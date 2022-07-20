// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthStore on _AuthStore, Store {
  Computed<String> _$uidComputed;

  @override
  String get uid => (_$uidComputed ??=
          Computed<String>(() => super.uid, name: '_AuthStore.uid'))
      .value;
  Computed<String> _$apiTokenComputed;

  @override
  String get apiToken => (_$apiTokenComputed ??=
          Computed<String>(() => super.apiToken, name: '_AuthStore.apiToken'))
      .value;
  Computed<AuthStatus> _$authStatusComputed;

  @override
  AuthStatus get authStatus =>
      (_$authStatusComputed ??= Computed<AuthStatus>(() => super.authStatus,
              name: '_AuthStore.authStatus'))
          .value;
  Computed<bool> _$isFetchingComputed;

  @override
  bool get isFetching => (_$isFetchingComputed ??=
          Computed<bool>(() => super.isFetching, name: '_AuthStore.isFetching'))
      .value;
  Computed<bool> _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<bool>(() => super.isAuthenticated,
              name: '_AuthStore.isAuthenticated'))
          .value;

  final _$smsAuthStatusAtom = Atom(name: '_AuthStore.smsAuthStatus');

  @override
  SmsAuthStatus get smsAuthStatus {
    _$smsAuthStatusAtom.reportRead();
    return super.smsAuthStatus;
  }

  @override
  set smsAuthStatus(SmsAuthStatus value) {
    _$smsAuthStatusAtom.reportWrite(value, super.smsAuthStatus, () {
      super.smsAuthStatus = value;
    });
  }

  final _$didVerifyLoginAtom = Atom(name: '_AuthStore.didVerifyLogin');

  @override
  bool get didVerifyLogin {
    _$didVerifyLoginAtom.reportRead();
    return super.didVerifyLogin;
  }

  @override
  set didVerifyLogin(bool value) {
    _$didVerifyLoginAtom.reportWrite(value, super.didVerifyLogin, () {
      super.didVerifyLogin = value;
    });
  }

  final _$_didVerifyDuplicatedAtom =
      Atom(name: '_AuthStore._didVerifyDuplicated');

  @override
  bool get _didVerifyDuplicated {
    _$_didVerifyDuplicatedAtom.reportRead();
    return super._didVerifyDuplicated;
  }

  @override
  set _didVerifyDuplicated(bool value) {
    _$_didVerifyDuplicatedAtom.reportWrite(value, super._didVerifyDuplicated,
        () {
      super._didVerifyDuplicated = value;
    });
  }

  final _$firebaseUserAtom = Atom(name: '_AuthStore.firebaseUser');

  @override
  FirebaseUser get firebaseUser {
    _$firebaseUserAtom.reportRead();
    return super.firebaseUser;
  }

  @override
  set firebaseUser(FirebaseUser value) {
    _$firebaseUserAtom.reportWrite(value, super.firebaseUser, () {
      super.firebaseUser = value;
    });
  }

  final _$firebaseTokenResultAtom =
      Atom(name: '_AuthStore.firebaseTokenResult');

  @override
  IdTokenResult get firebaseTokenResult {
    _$firebaseTokenResultAtom.reportRead();
    return super.firebaseTokenResult;
  }

  @override
  set firebaseTokenResult(IdTokenResult value) {
    _$firebaseTokenResultAtom.reportWrite(value, super.firebaseTokenResult, () {
      super.firebaseTokenResult = value;
    });
  }

  final _$currentUserAtom = Atom(name: '_AuthStore.currentUser');

  @override
  UserModel get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(UserModel value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  final _$currentUserFriendsAtom = Atom(name: '_AuthStore.currentUserFriends');

  @override
  ObservableList<String> get currentUserFriends {
    _$currentUserFriendsAtom.reportRead();
    return super.currentUserFriends;
  }

  @override
  set currentUserFriends(ObservableList<String> value) {
    _$currentUserFriendsAtom.reportWrite(value, super.currentUserFriends, () {
      super.currentUserFriends = value;
    });
  }

  final _$currentNotificationTokenAtom =
      Atom(name: '_AuthStore.currentNotificationToken');

  @override
  String get currentNotificationToken {
    _$currentNotificationTokenAtom.reportRead();
    return super.currentNotificationToken;
  }

  @override
  set currentNotificationToken(String value) {
    _$currentNotificationTokenAtom
        .reportWrite(value, super.currentNotificationToken, () {
      super.currentNotificationToken = value;
    });
  }

  final _$setFirebaseUserAsyncAction =
      AsyncAction('_AuthStore.setFirebaseUser');

  @override
  Future setFirebaseUser(FirebaseUser newUser) {
    return _$setFirebaseUserAsyncAction
        .run(() => super.setFirebaseUser(newUser));
  }

  final _$_AuthStoreActionController = ActionController(name: '_AuthStore');

  @override
  dynamic clearStore() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.clearStore');
    try {
      return super.clearStore();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSmsAuthStatus(SmsAuthStatus newValue) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setSmsAuthStatus');
    try {
      return super.setSmsAuthStatus(newValue);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDidVerifyLogin() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setDidVerifyLogin');
    try {
      return super.setDidVerifyLogin();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDidVerifyDuplicated(bool newValue) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setDidVerifyDuplicated');
    try {
      return super.setDidVerifyDuplicated(newValue);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentNotificationToken(String newToken) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setCurrentNotificationToken');
    try {
      return super.setCurrentNotificationToken(newToken);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFirebaseTokenResult(IdTokenResult newValue) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setFirebaseTokenResult');
    try {
      return super.setFirebaseTokenResult(newValue);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentUser(UserModel newUser) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setCurrentUser');
    try {
      return super.setCurrentUser(newUser);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentUserFriends(List<String> newList) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setCurrentUserFriends');
    try {
      return super.setCurrentUserFriends(newList);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
smsAuthStatus: ${smsAuthStatus},
didVerifyLogin: ${didVerifyLogin},
firebaseUser: ${firebaseUser},
firebaseTokenResult: ${firebaseTokenResult},
currentUser: ${currentUser},
currentUserFriends: ${currentUserFriends},
currentNotificationToken: ${currentNotificationToken},
uid: ${uid},
apiToken: ${apiToken},
authStatus: ${authStatus},
isFetching: ${isFetching},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
