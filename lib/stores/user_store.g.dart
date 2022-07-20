// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStoreBase, Store {
  Computed<bool> _$isCurrentUserComputed;

  @override
  bool get isCurrentUser =>
      (_$isCurrentUserComputed ??= Computed<bool>(() => super.isCurrentUser,
              name: '_UserStoreBase.isCurrentUser'))
          .value;
  Computed<bool> _$isFetchingComputed;

  @override
  bool get isFetching =>
      (_$isFetchingComputed ??= Computed<bool>(() => super.isFetching,
              name: '_UserStoreBase.isFetching'))
          .value;
  Computed<List<BookModel>> _$booksLibraryComputed;

  @override
  List<BookModel> get booksLibrary => (_$booksLibraryComputed ??=
          Computed<List<BookModel>>(() => super.booksLibrary,
              name: '_UserStoreBase.booksLibrary'))
      .value;

  final _$_fetchingStatusAtom = Atom(name: '_UserStoreBase._fetchingStatus');

  @override
  _FetchingStatus get _fetchingStatus {
    _$_fetchingStatusAtom.reportRead();
    return super._fetchingStatus;
  }

  @override
  set _fetchingStatus(_FetchingStatus value) {
    _$_fetchingStatusAtom.reportWrite(value, super._fetchingStatus, () {
      super._fetchingStatus = value;
    });
  }

  final _$isFetchingBooksAtom = Atom(name: '_UserStoreBase.isFetchingBooks');

  @override
  bool get isFetchingBooks {
    _$isFetchingBooksAtom.reportRead();
    return super.isFetchingBooks;
  }

  @override
  set isFetchingBooks(bool value) {
    _$isFetchingBooksAtom.reportWrite(value, super.isFetchingBooks, () {
      super.isFetchingBooks = value;
    });
  }

  final _$userIdAtom = Atom(name: '_UserStoreBase.userId');

  @override
  String get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$userAtom = Atom(name: '_UserStoreBase.user');

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$userBooksListAtom = Atom(name: '_UserStoreBase.userBooksList');

  @override
  ObservableList<BookModel> get userBooksList {
    _$userBooksListAtom.reportRead();
    return super.userBooksList;
  }

  @override
  set userBooksList(ObservableList<BookModel> value) {
    _$userBooksListAtom.reportWrite(value, super.userBooksList, () {
      super.userBooksList = value;
    });
  }

  final _$_UserStoreBaseActionController =
      ActionController(name: '_UserStoreBase');

  @override
  void clearStore() {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.clearStore');
    try {
      return super.clearStore();
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserFetchingStatus(_FetchingStatus newValue) {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.setUserFetchingStatus');
    try {
      return super.setUserFetchingStatus(newValue);
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsFetchingBooks(bool newValue) {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.setIsFetchingBooks');
    try {
      return super.setIsFetchingBooks(newValue);
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserId(String newValue) {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.setUserId');
    try {
      return super.setUserId(newValue);
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUser(UserModel newValue) {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.setUser');
    try {
      return super.setUser(newValue);
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserBooksList(List<BookModel> newValue) {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.setUserBooksList');
    try {
      return super.setUserBooksList(newValue);
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isFetchingBooks: ${isFetchingBooks},
userId: ${userId},
user: ${user},
userBooksList: ${userBooksList},
isCurrentUser: ${isCurrentUser},
isFetching: ${isFetching},
booksLibrary: ${booksLibrary}
    ''';
  }
}
