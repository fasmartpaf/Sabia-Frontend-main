// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FriendsPageStore on _FriendsPageStoreBase, Store {
  Computed<bool> _$hasContactsPermissionComputed;

  @override
  bool get hasContactsPermission => (_$hasContactsPermissionComputed ??=
          Computed<bool>(() => super.hasContactsPermission,
              name: '_FriendsPageStoreBase.hasContactsPermission'))
      .value;
  Computed<List<String>> _$_friendsPhonesListComputed;

  @override
  List<String> get _friendsPhonesList => (_$_friendsPhonesListComputed ??=
          Computed<List<String>>(() => super._friendsPhonesList,
              name: '_FriendsPageStoreBase._friendsPhonesList'))
      .value;
  Computed<List<UserModel>> _$filteredCurrentUserFriendsComputed;

  @override
  List<UserModel> get filteredCurrentUserFriends =>
      (_$filteredCurrentUserFriendsComputed ??= Computed<List<UserModel>>(
              () => super.filteredCurrentUserFriends,
              name: '_FriendsPageStoreBase.filteredCurrentUserFriends'))
          .value;
  Computed<List<ContactModel>> _$notFriendContactsComputed;

  @override
  List<ContactModel> get notFriendContacts => (_$notFriendContactsComputed ??=
          Computed<List<ContactModel>>(() => super.notFriendContacts,
              name: '_FriendsPageStoreBase.notFriendContacts'))
      .value;
  Computed<List<ContactModel>> _$filteredNotFriendContactsComputed;

  @override
  List<ContactModel> get filteredNotFriendContacts =>
      (_$filteredNotFriendContactsComputed ??= Computed<List<ContactModel>>(
              () => super.filteredNotFriendContacts,
              name: '_FriendsPageStoreBase.filteredNotFriendContacts'))
          .value;
  Computed<List<String>> _$contactsPhonesComputed;

  @override
  List<String> get contactsPhones => (_$contactsPhonesComputed ??=
          Computed<List<String>>(() => super.contactsPhones,
              name: '_FriendsPageStoreBase.contactsPhones'))
      .value;

  final _$searchStringAtom = Atom(name: '_FriendsPageStoreBase.searchString');

  @override
  String get searchString {
    _$searchStringAtom.reportRead();
    return super.searchString;
  }

  @override
  set searchString(String value) {
    _$searchStringAtom.reportWrite(value, super.searchString, () {
      super.searchString = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_FriendsPageStoreBase.isFetching');

  @override
  bool get isFetching {
    _$isFetchingAtom.reportRead();
    return super.isFetching;
  }

  @override
  set isFetching(bool value) {
    _$isFetchingAtom.reportWrite(value, super.isFetching, () {
      super.isFetching = value;
    });
  }

  final _$isFetchingContactsAtom =
      Atom(name: '_FriendsPageStoreBase.isFetchingContacts');

  @override
  bool get isFetchingContacts {
    _$isFetchingContactsAtom.reportRead();
    return super.isFetchingContacts;
  }

  @override
  set isFetchingContacts(bool value) {
    _$isFetchingContactsAtom.reportWrite(value, super.isFetchingContacts, () {
      super.isFetchingContacts = value;
    });
  }

  final _$currentUserFriendsAtom =
      Atom(name: '_FriendsPageStoreBase.currentUserFriends');

  @override
  ObservableList<UserModel> get currentUserFriends {
    _$currentUserFriendsAtom.reportRead();
    return super.currentUserFriends;
  }

  @override
  set currentUserFriends(ObservableList<UserModel> value) {
    _$currentUserFriendsAtom.reportWrite(value, super.currentUserFriends, () {
      super.currentUserFriends = value;
    });
  }

  final _$userContactsListAtom =
      Atom(name: '_FriendsPageStoreBase.userContactsList');

  @override
  ObservableList<ContactModel> get userContactsList {
    _$userContactsListAtom.reportRead();
    return super.userContactsList;
  }

  @override
  set userContactsList(ObservableList<ContactModel> value) {
    _$userContactsListAtom.reportWrite(value, super.userContactsList, () {
      super.userContactsList = value;
    });
  }

  final _$_phonesAreValidUsersAtom =
      Atom(name: '_FriendsPageStoreBase._phonesAreValidUsers');

  @override
  ObservableMap<String, UserModel> get _phonesAreValidUsers {
    _$_phonesAreValidUsersAtom.reportRead();
    return super._phonesAreValidUsers;
  }

  @override
  set _phonesAreValidUsers(ObservableMap<String, UserModel> value) {
    _$_phonesAreValidUsersAtom.reportWrite(value, super._phonesAreValidUsers,
        () {
      super._phonesAreValidUsers = value;
    });
  }

  final _$permissionStatusAtom =
      Atom(name: '_FriendsPageStoreBase.permissionStatus');

  @override
  EPermissionStatus get permissionStatus {
    _$permissionStatusAtom.reportRead();
    return super.permissionStatus;
  }

  @override
  set permissionStatus(EPermissionStatus value) {
    _$permissionStatusAtom.reportWrite(value, super.permissionStatus, () {
      super.permissionStatus = value;
    });
  }

  final _$_FriendsPageStoreBaseActionController =
      ActionController(name: '_FriendsPageStoreBase');

  @override
  dynamic setSearchString(String newValue) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase.setSearchString');
    try {
      return super.setSearchString(newValue);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setCurrentUserFriends(List<UserModel> newList) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase._setCurrentUserFriends');
    try {
      return super._setCurrentUserFriends(newList);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setUserContactsList(List<ContactModel> newList) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase._setUserContactsList');
    try {
      return super._setUserContactsList(newList);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setPhonesAreValidUsers(Map<String, UserModel> newMap) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase._setPhonesAreValidUsers');
    try {
      return super._setPhonesAreValidUsers(newMap);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setIsFetching(bool newValue) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase._setIsFetching');
    try {
      return super._setIsFetching(newValue);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setIsFetchingContacts(bool newValue) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase._setIsFetchingContacts');
    try {
      return super._setIsFetchingContacts(newValue);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setPermissionStatus(EPermissionStatus newStatus) {
    final _$actionInfo = _$_FriendsPageStoreBaseActionController.startAction(
        name: '_FriendsPageStoreBase._setPermissionStatus');
    try {
      return super._setPermissionStatus(newStatus);
    } finally {
      _$_FriendsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchString: ${searchString},
isFetching: ${isFetching},
isFetchingContacts: ${isFetchingContacts},
currentUserFriends: ${currentUserFriends},
userContactsList: ${userContactsList},
permissionStatus: ${permissionStatus},
hasContactsPermission: ${hasContactsPermission},
filteredCurrentUserFriends: ${filteredCurrentUserFriends},
notFriendContacts: ${notFriendContacts},
filteredNotFriendContacts: ${filteredNotFriendContacts},
contactsPhones: ${contactsPhones}
    ''';
  }
}
