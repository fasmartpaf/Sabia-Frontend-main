import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:pedantic/pedantic.dart';

import '../routes/app_routes.dart';
import '../components/icon/app_icon.dart';

import '../model/user_model.dart';
import '../interfaces/crash_report_service_interface.dart';
import '../interfaces/images_service_interface.dart';
import '../services/sabia_api_service.dart';
import '../services/notifications_service.dart';
import '../services/firebase_service.dart';
import 'analytics_store.dart';
import 'routing_store.dart';

part "auth_store.g.dart";

class AuthStore = _AuthStore with _$AuthStore;

enum AuthStatus {
  fetching,
  notAuthenticated,
  authenticated,
  missingName,
}

enum SmsAuthStatus {
  initial,
  waitingCode,
  success,
  error,
}

abstract class _AuthStore extends Disposable with Store {
  List<ReactionDisposer> _disposersList;
  final AnalyticsStore _analyticsStore;
  final RoutingStore _routingStore;
  final FirebaseAuth _firebaseAuth;
  final SabiaApiService _sabiaApiService;
  final FirebaseService _firebaseService;
  final CrashReportServiceInterface _crashReportService;
  final ImagesServiceInterface _imagesService;
  final NotificationsService _notificationsService;

  String smsVerificationId;

  dynamic _currentUserDataListener;
  dynamic _currentUserFriendsListener;
  dynamic _currentUserDidReadBooksIsbnListener;

  @observable
  SmsAuthStatus smsAuthStatus = SmsAuthStatus.initial;

  @observable
  bool didVerifyLogin = false;
  @observable
  bool _didVerifyDuplicated = false;

  @observable
  FirebaseUser firebaseUser;

  @observable
  IdTokenResult firebaseTokenResult;

  @observable
  UserModel currentUser;

  @observable
  ObservableList<String> currentUserFriends = ObservableList<String>();

  @observable
  String currentNotificationToken;

  _AuthStore(
    this._analyticsStore,
    this._routingStore,
    this._firebaseAuth,
    this._sabiaApiService,
    this._firebaseService,
    this._crashReportService,
    this._imagesService,
    this._notificationsService,
  ) {
    this._disposersList ??= [
      reaction(
        (_) => firebaseUser != null && _didVerifyDuplicated,
        (bool canRetrieveAccount) {
          if (canRetrieveAccount) {
            this._setCurrentUserDataListener();
            this._setCurrentUserFriendsListener();
          } else {
            this.clearStore();
          }
        },
      ),
      reaction(
        (_) => this.authStatus == AuthStatus.authenticated,
        (bool isAuthenticated) {
          if (isAuthenticated) {
            this._routingStore.moveToMainRoute(APP_ROUTE.HOME.path);

            this.setDidReadBooksIsbnListener();
          } else {
            this.clearStore();
          }
        },
      ),
      reaction(
          (_) => [
                this.currentNotificationToken,
                this.currentUser,
              ], (_) {
        if (this.currentUser != null &&
            (this.currentNotificationToken?.isNotEmpty ?? false)) {
          this._setNotificationTokenNewValue(true);
        }
      }, delay: 10000),
    ];
    this._firebaseAuth.onAuthStateChanged.listen(
          (FirebaseUser user) => this.setFirebaseUser(user),
        );
    unawaited(this.getTokenResults());

    Future.delayed(
      Duration(seconds: 10),
      () {
        if (!this.didVerifyLogin) {
          this.logout();
          this.setDidVerifyLogin();
        }
      },
    );
  }

  @override
  dispose() {
    this._disposersList?.forEach((d) => d());
  }

  @action
  clearStore() {
    this.currentUser = null;
    this.smsAuthStatus = SmsAuthStatus.initial;
    this._currentUserDataListener?.cancel();
    this._currentUserFriendsListener?.cancel();
    this._currentUserDidReadBooksIsbnListener?.cancel();

    this.currentUserFriends.clear();
  }

  @action
  setSmsAuthStatus(SmsAuthStatus newValue) => this.smsAuthStatus = newValue;
  @action
  void setDidVerifyLogin() => this.didVerifyLogin = true;
  @action
  void setDidVerifyDuplicated(bool newValue) =>
      this._didVerifyDuplicated = newValue;

  @action
  setCurrentNotificationToken(String newToken) =>
      this.currentNotificationToken = newToken ?? "";

  @action
  setFirebaseUser(FirebaseUser newUser) async {
    this.firebaseUser = newUser;
    unawaited(this.getTokenResults());

    if (newUser != null) {
      final isDuplicated =
          await this.verifyIfDuplicatedUserAccount(newUser.phoneNumber);

      if (isDuplicated) {
        this._notificationsService.notifyInfo(
              "Seu perfil passou por uma atualização de segurança necessária. Por favor faça login novamente.",
              timeout: 10,
            );
        await this.logout();
      } else {
        this.setDidVerifyDuplicated(true);

        unawaited(this._analyticsStore.logLogin(
              newUser.isAnonymous ? "anonymous" : "email",
            ));
      }
    }

    this.setDidVerifyLogin();
  }

  @action
  setFirebaseTokenResult(IdTokenResult newValue) =>
      this.firebaseTokenResult = newValue;
  @action
  setCurrentUser(UserModel newUser) {
    this.currentUser = newUser;

    _crashReportService.setUserData(
      newUser?.id ?? "",
      email: newUser?.email ?? "",
      name: newUser?.name ?? "",
    );
  }

  @action
  setCurrentUserFriends(List<String> newList) {
    this.currentUserFriends = newList.asObservable();
  }

  @computed
  String get uid => this.firebaseUser?.uid;

  @computed
  String get apiToken => this.firebaseTokenResult?.token;

  @computed
  AuthStatus get authStatus {
    if (!this.didVerifyLogin) return AuthStatus.fetching;
    if (!this.isAuthenticated) return AuthStatus.notAuthenticated;
    if (this.currentUser.name.isEmpty) return AuthStatus.missingName;
    return AuthStatus.authenticated;
  }

  @computed
  bool get isFetching => this.authStatus == AuthStatus.fetching;

  @computed
  bool get isAuthenticated => this.currentUser != null;

  _notifyErrorMessage(String message) {
    this._notificationsService.notifyError(message);
  }

  _setNotificationTokenNewValue(dynamic newValue) {
    if (this.currentNotificationToken == null ||
        this.authStatus != AuthStatus.authenticated) {
      return;
    }
    Map<String, dynamic> updates = {
      "users/${this.uid}/notificationTokens/${this.currentNotificationToken}":
          newValue
    };

    this._firebaseService.scheduleRootUpdates(updates);
  }

  Future<void> reloadUser() async {
    await this.firebaseUser?.reload();
    await this.getTokenResults();
  }

  Future<bool> verifyIfDuplicatedUserAccount(
    String phoneNumber,
  ) async {
    try {
      final response = await this
          ._sabiaApiService
          .verifyAndFixDuplicatedUserWithPhoneNumber(phoneNumber);
      return response.statusCode == 200;
    } catch (e) {
      print("error in verifyIfDuplicatedUserAccount $e");
      return false;
    }
  }

  void _setCurrentUserDataListener() {
    this._currentUserDataListener?.cancel();
    this._currentUserDataListener = this
        ._firebaseService
        .usersRef
        .child(this.uid)
        .onValue
        .listen((Event event) {
      final snapshot = event.snapshot;
      final Map<String, dynamic> data = snapshot.value != null
          ? Map<String, dynamic>.from(snapshot.value)
          : {};
      final user = UserModel.fromMap({"id": this.uid, ...data});
      this._tryToGetCurrentUserImage();
      this.setCurrentUser(user);
    });
  }

  void _setCurrentUserFriendsListener() {
    this._currentUserFriendsListener?.cancel();
    this._currentUserFriendsListener = this
        ._firebaseService
        .userFriendsRef
        .child(this.uid)
        .onValue
        .listen((Event event) {
      final snapshot = event.snapshot;

      List<String> list = [];
      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          list.add(key);
        });
      }
      this.setCurrentUserFriends(list);
    });
  }

  bool currentUserDidReadBook({String isbn}) => this.currentUser != null
      ? this.currentUser.didReadBooksIsbn.contains(isbn)
      : false;
  bool currentUserDidWantToReadLaterBook({String isbn}) =>
      this.currentUser != null
          ? this.currentUser.readLaterBooksIsbn.contains(isbn)
          : false;

  _didVerifyPhone(AuthCredential phoneAuthCredential) {
    this.setSmsAuthStatus(SmsAuthStatus.success);
  }

  Future<void> submitLogin({String phone}) async {
    final ref = this._firebaseService.rootRef.child("logs").push();
    unawaited(ref.set({"source": "submitLogin", "phone": phone}));

    final PhoneVerificationFailed verificationFailed = (
      AuthException authException,
    ) {
      this.setSmsAuthStatus(SmsAuthStatus.error);

      this._notificationsService.notifyDanger(
            authException.message,
          );

      final ref = this._firebaseService.rootRef.child("logs").push();

      ref.set({"source": "verificationFailed", "authException": authException});
      this.handleFirebaseAuthError(authException.code);
    };
    final PhoneCodeSent codeSent = (
      String verificationId, [
      int forceResendingToken,
    ]) async {
      this.smsVerificationId = verificationId;
      this.setSmsAuthStatus(SmsAuthStatus.waitingCode);
      debugPrint("codeSent $verificationId");
      this._notificationsService.notifySuccess(
            "Código enviado por SMS",
            icon: CheckIcon,
          );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.smsVerificationId = verificationId;
      debugPrint("codeAutoRetrievalTimeout: $verificationId");

      final ref = this._firebaseService.rootRef.child("logs").push();
      ref.set({
        "source": "codeAutoRetrievalTimeout",
        "verificationId": verificationId
      });
    };

    try {
      await this._firebaseAuth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: const Duration(minutes: 1),
            verificationCompleted: _didVerifyPhone,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          );
    } on PlatformException catch (e) {
      handleFirebaseAuthError(e.code);
    }
  }

  Future<bool> loginWithCode(String code) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: this.smsVerificationId,
        smsCode: code,
      );
      final authResult =
          await this._firebaseAuth.signInWithCredential(credential);

      if (authResult.user != null) {
        this.setFirebaseUser(authResult.user);
        this.setSmsAuthStatus(SmsAuthStatus.success);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      handleFirebaseAuthError(e.code);
      return false;
    }
  }

  Future<void> updateProfile({
    String name,
    String email,
    String location,
    bool isPublicProfile = true,
  }) async {
    try {
      await this._firebaseService.usersRef.child(uid).update({
        "name": name ?? "",
        "email": email ?? "",
        "location": location ?? "",
        "phone": this.firebaseUser.phoneNumber,
        "isPublicProfile": isPublicProfile,
      });

      if (this.authStatus == AuthStatus.missingName) {
        unawaited(this._analyticsStore.logSignup("sms"));
      }
    } catch (e) {
      debugPrint("error in updateProfile $e");
    }
  }

  Future<void> getTokenResults() async {
    IdTokenResult tokenResults;
    try {
      if (this.firebaseUser != null) {
        tokenResults = await this.firebaseUser.getIdToken();
      }
    } catch (e) {
      tokenResults = null;
    } finally {
      this.setFirebaseTokenResult(tokenResults);
    }
  }

  Future<void> logout() async {
    this.setDidVerifyDuplicated(false);
    this._setNotificationTokenNewValue(null);

    this.clearStore();

    this._routingStore.moveToMainRoute(APP_ROUTE.LOGIN.path);

    await this._firebaseAuth.signOut();
  }

  handleFirebaseAuthError(String code) {
    if (code == "ERROR_INVALID_EMAIL") {
      this._notifyErrorMessage("O e-mail informado é inválido.");
    } else if (code == "ERROR_WRONG_PASSWORD") {
      this._notifyErrorMessage(
          "Login incorreto, verifique seu e-mail e senha.");
    } else if (code == "ERROR_TOO_MANY_REQUESTS" || code == "quotaExceeded") {
      this._notifyErrorMessage(
          "Dispositivo bloqueado temporariamente. Tente novamente mais tarde.");
    } else if (code == "ERROR_USER_DISABLED") {
      this._notifyErrorMessage(
          "Seu usuário está bloqueado. Entre em contato com o suporte.");
    } else if (code == "ERROR_USER_NOT_FOUND") {
      this._notifyErrorMessage("Usuário não encontrado. Faça seu registro.");
    } else if (code == "ERROR_WEAK_PASSWORD") {
      this._notifyErrorMessage(
          "A senha informada é muito frágil. Por favor utilize letras, números e símbolos para criar uma senha segura.");
    } else if (code == "ERROR_EMAIL_ALREADY_IN_USE") {
      this._notifyErrorMessage(
          "E-mail já registrado para outro usuário. Faça login.");
    } else if (code == "ERROR_INVALID_VERIFICATION_CODE") {
      this._notifyErrorMessage("O código informado é inválido");
    } else if (code == "verifyPhoneNumberError") {
      this._notifyErrorMessage(
          "Erro ao validar seu número. Por favor tente novamente.");
    }
  }

  Future<void> _tryToGetCurrentUserImage() async {
    if (this.currentUser?.image == null) {
      await Future.delayed(Duration(seconds: 3));
      return this._tryToGetCurrentUserImage();
    }
    if (this.currentUser?.imageUrl == null) {
      await this._imagesService.getUserImage(this.currentUser);

      Future.delayed(Duration(seconds: 3), this._tryToGetCurrentUserImage);
    }
  }

  Future<void> setDidReadBooksIsbnListener() async {
    if (this.currentUser == null) return;

    this._currentUserDidReadBooksIsbnListener?.cancel();
    this._currentUserDidReadBooksIsbnListener = this
        ._firebaseService
        .userReviewsOfBooksRef
        .child(this.uid)
        .onValue
        .listen((Event event) {
      final snapshot = event.snapshot;
      final Map<String, dynamic> data = snapshot.value != null
          ? Map<String, dynamic>.from(snapshot.value)
          : {};
      final list = List<String>.from(data.keys);

      this.currentUser.setDidRead(list);
    });
  }
}
