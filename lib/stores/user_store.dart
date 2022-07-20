import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart' show Disposable;
import 'package:mobx/mobx.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sabia_app/model/book/book_model.dart';
import 'package:sabia_app/services/sabia_api_service.dart';

import 'auth_store.dart';
import 'book_store.dart';

import '../interfaces/images_service_interface.dart';
import '../model/user_model.dart';
import '../services/firebase_service.dart';
import '../utils/constants.dart';
part 'user_store.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

enum _FetchingStatus {
  fetching,
  found,
  notFound,
}

abstract class _UserStoreBase extends Disposable with Store {
  List<ReactionDisposer> _disposersList;
  final AuthStore _authStore;
  final BookStore _bookStore;
  final FirebaseService _firebaseService;
  final SabiaApiService _sabiaApiService;
  final ImagesServiceInterface _imagesService;

  _UserStoreBase(
    this._authStore,
    this._bookStore,
    this._firebaseService,
    this._sabiaApiService,
    this._imagesService,
  ) {
    this._disposersList ??= [
      reaction((_) => this.userId, (String id) {
        if (id != null) {
          this._getUser();
        } else {
          this.clearStore();
        }
      }),
      reaction((_) => this.user != null, (bool hasUser) {
        if (hasUser) {
          this.fetchUserBooks();
        } else {
          this.setUserBooksList([]);
        }
      }),
    ];
  }

  @override
  void dispose() => _disposersList?.forEach((d) => d());

  @observable
  _FetchingStatus _fetchingStatus = _FetchingStatus.fetching;
  @observable
  bool isFetchingBooks = false;
  @observable
  String userId;
  @observable
  UserModel user;

  @observable
  ObservableList<BookModel> userBooksList = ObservableList<BookModel>();

  @action
  void clearStore() {
    this._fetchingStatus = _FetchingStatus.fetching;
    this.isFetchingBooks = false;
    this.userId = null;
    this.user = null;
  }

  @action
  setUserFetchingStatus(_FetchingStatus newValue) =>
      this._fetchingStatus = newValue;

  @action
  setIsFetchingBooks(bool newValue) => this.isFetchingBooks = newValue;
  @action
  setUserId(String newValue) {
    if (newValue == this.userId) {
      return;
    }
    if (this.userId != null) {
      this.userId = null;
      Future.delayed(
        Duration(milliseconds: 300),
        () => this.setUserId(newValue),
      );
    } else {
      this.userId = newValue;
    }
  }

  @action
  setUser(UserModel newValue) => this.user = newValue;

  @action
  setUserBooksList(List<BookModel> newValue) =>
      this.userBooksList = newValue.asObservable();

  @computed
  bool get isCurrentUser => userId != null && userId == this._authStore.uid;

  @computed
  bool get isFetching => this._fetchingStatus == _FetchingStatus.fetching;

  @computed
  List<BookModel> get booksLibrary {
    if (this.isCurrentUser) {
      return this._bookStore.currentUserBooksLibrary;
    }
    return this.userBooksList;
  }

  Future<void> _getUser() async {
    if (this.isCurrentUser) {
      this.setUser(this._authStore.currentUser);
      this.setUserFetchingStatus(_FetchingStatus.found);
      return;
    }
    this.setUserFetchingStatus(_FetchingStatus.fetching);
    final snapshot =
        await this._firebaseService.usersRef.child(this.userId).once();
    if (snapshot.value == null) {
      this.setUserFetchingStatus(_FetchingStatus.notFound);
      return;
    }

    final Map<String, dynamic> data =
        snapshot.value != null ? Map<String, dynamic>.from(snapshot.value) : {};

    final user = UserModel.fromMap({
      ...data,
      "id": this.userId,
    });

    if (user.image == null) {
      unawaited(this._imagesService.getUserImage(user));
    }

    this.setUser(user);
    this.setUserFetchingStatus(_FetchingStatus.found);
  }

  Future<void> setUserProfileImage(File image) async {
    try {
      await this._imagesService.uploadUserProfileImage(image, user: this.user);

      await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      print("error in setUserProfileImage $e");
    }
  }

  Future<void> removeUserProfileImage() async {
    if (this.user.image == null) {
      return;
    }
    try {
      final imagePath = "/users/${this.user.id}/${this.user.image.id}";
      await this._imagesService.deleteImage("$imagePath.jpg");
      for (final size in IMAGE_SIZES) {
        await this._imagesService.deleteImage("$imagePath$size.jpg");
      }

      await this
          ._firebaseService
          .usersRef
          .child(this.user.id)
          .child("image")
          .remove();
    } catch (e) {
      print("error on removeUserProfileImage $e");
    }
  }

  void fetchUserBooks() async {
    if (this.userId == null) {
      return;
    }
    this.setIsFetchingBooks(true);
    if (this.isCurrentUser) {
      await this._bookStore.fetchCurrentUserBooks();
    } else {
      final list = await this._bookStore.fetchUserBooks(this.userId);
      this.setUserBooksList(list);
    }
    this.setIsFetchingBooks(false);
  }

  bool isFriendOfCurrentUser(String userId) {
    return this._authStore.currentUserFriends.contains(userId);
  }

  Future<void> didAddUserAsFriend(String userId) async {
    try {
      await this
          ._firebaseService
          .userFriendsRef
          .child(this._authStore.uid)
          .child(userId)
          .set(true);
    } catch (e) {
      print("error in didAddUserAsFriend $e");
    }
  }

  Future<void> didRemoveUserAsFriend(String userId) async {
    try {
      await this
          ._firebaseService
          .userFriendsRef
          .child(this._authStore.uid)
          .child(userId)
          .remove();
    } catch (e) {
      print("error in didRemoveUserAsFriend $e");
    }
  }

  Future<List<UserModel>> getCurrentUserFriendsData() async {
    List<UserModel> friends = [];
    try {
      for (var friendId in this._authStore.currentUserFriends) {
        final snapshot =
            await this._firebaseService.usersRef.child(friendId).once();
        if (snapshot.value != null) {
          final friend = UserModel.fromMap({
            ...snapshot.value,
            "id": friendId,
          });
          if (friend != null) {
            friends.add(friend);
          }
        }
      }
    } catch (e) {
      print("error in getCurrentUserFriendsData $e");
    }

    friends.sort((a, b) => a.name.compareTo(b.name));

    return friends;
  }

  Future<Map<String, UserModel>> thereAreValidUsersForPhones(
    List<String> phones,
  ) async {
    Map<String, UserModel> result = {};
    try {
      final response =
          await this._sabiaApiService.thereAreValidUsersForPhones(phones);
      final responseMap =
          Map<String, Map<dynamic, dynamic>>.from(response.data);
      for (var key in responseMap.keys) {
        final user = UserModel.fromMap(responseMap[key]);
        if (user.id != null && user.name != null && user.phone != null) {
          result[key] = user;
        }
      }
    } catch (e) {
      print("error in thereAreValidUsersForPhones $e");

      phones.forEach((p) => result[p] = null);
    }

    return result;
  }
}
