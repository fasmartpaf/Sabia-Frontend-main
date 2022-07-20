import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:sabia_app/model/contact_model.dart';
import 'package:sabia_app/model/user_model.dart';
import 'package:sabia_app/services/user_permission_service.dart';
import 'package:sabia_app/utils/constants.dart';
import 'package:sabia_app/utils/phone_utils.dart';
import 'package:sabia_app/utils/utils.dart';

part 'friends_page_store.g.dart';

class FriendsPageStore = _FriendsPageStoreBase with _$FriendsPageStore;

abstract class _FriendsPageStoreBase extends Disposable with Store {
  @visibleForTesting
  final String currentUserId;
  final Future<EPermissionStatus> Function() _verifyPermissionStatus;
  final Future<EPermissionStatus> Function() _requestPermission;
  final Future<List<UserModel>> Function(String userId) _getUserFriends;
  Future<Map<String, UserModel>> Function(List<String> phones)
      _thereAreValidUsersForPhones;
  final Future<List<ContactModel>> Function() _getUserContacts;
  final Future<void> Function(String userId) _addUserAsFriend;

  List<ReactionDisposer> _disposersList;

  @observable
  String searchString = "";
  @observable
  bool isFetching = false;
  @observable
  bool isFetchingContacts = false;
  @observable
  ObservableList<UserModel> currentUserFriends = ObservableList<UserModel>();
  @observable
  ObservableList<ContactModel> userContactsList =
      ObservableList<ContactModel>();

  @observable
  ObservableMap<String, UserModel> _phonesAreValidUsers =
      ObservableMap<String, UserModel>();

  @observable
  EPermissionStatus permissionStatus = EPermissionStatus.undetermined;

  _FriendsPageStoreBase(
    this.currentUserId,
    this._verifyPermissionStatus,
    this._requestPermission,
    this._getUserFriends,
    this._thereAreValidUsersForPhones,
    this._getUserContacts,
    this._addUserAsFriend,
  ) {
    this._verifyContactPermissionStatus();

    this._disposersList ??= [
      reaction((_) => this.hasContactsPermission, (_) {
        this.requestContacts();
      }),
      reaction((_) => this.userContactsList, (_) {
        this.verifyPhonesAreValidUsers();
      }),
    ];
  }

  @override
  void dispose() => _disposersList?.forEach((d) => d());

  @action
  setSearchString(String newValue) => this.searchString = newValue;

  @action
  _setCurrentUserFriends(List<UserModel> newList) {
    this.currentUserFriends = newList.asObservable();
  }

  @action
  _setUserContactsList(List<ContactModel> newList) {
    this.userContactsList = newList.asObservable();
  }

  @action
  _setPhonesAreValidUsers(Map<String, UserModel> newMap) {
    this._phonesAreValidUsers = newMap.asObservable();
  }

  @action
  _setIsFetching(bool newValue) => this.isFetching = newValue;
  @action
  _setIsFetchingContacts(bool newValue) => this.isFetchingContacts = newValue;
  @action
  _setPermissionStatus(EPermissionStatus newStatus) =>
      this.permissionStatus = newStatus;

  @computed
  bool get hasContactsPermission {
    return this.permissionStatus == EPermissionStatus.granted;
  }

  @computed
  List<String> get _friendsPhonesList {
    return this.currentUserFriends.map((friend) => friend.phone).toList();
  }

  @computed
  List<UserModel> get filteredCurrentUserFriends {
    if (this.searchString.isEmpty) {
      return this.currentUserFriends;
    }

    return this
        .currentUserFriends
        .where((user) => user.name.toLowerCase().contains(
              this.searchString.toLowerCase(),
            ))
        .toList();
  }

  @computed
  List<ContactModel> get notFriendContacts {
    var list = this.userContactsList.where((contact) {
      bool isNotFriend = true;

      for (var phone in contact.phones) {
        final didExists = this._friendsPhonesList.firstWhere(
              (p) => phone.contains(phoneLastEightDigits(p)),
              orElse: () => null,
            );
        isNotFriend = didExists == null;
      }

      return isNotFriend;
    }).toList();

    list.sort((a, b) {
      if (arePhonesValidUser(a.phones)) {
        return -1;
      }
      if (arePhonesValidUser(b.phones)) {
        return 1;
      }

      return 0;
    });

    return list;
  }

  @computed
  List<ContactModel> get filteredNotFriendContacts {
    if (this.searchString.isEmpty) {
      return this.notFriendContacts;
    }
    return this
        .notFriendContacts
        .where((contact) => contact.name.toLowerCase().contains(
              this.searchString.toLowerCase(),
            ))
        .toList();
  }

  @computed
  List<String> get contactsPhones {
    List<String> phones = [];

    for (var contact in this.userContactsList) {
      for (var phone in contact.phones) {
        phones.add(phone);
      }
    }

    return phones;
  }

  void clearStore() {
    this.setSearchString("");
  }

  bool arePhonesValidUser(List<String> phones) {
    if (_phonesAreValidUsers.keys.isEmpty) {
      return false;
    }
    return phones.any((p) => this._phonesAreValidUsers[p] != null);
  }

  UserModel _getValidUserForPhones(List<String> phones) {
    UserModel user;
    for (var p in phones) {
      if (user == null && this._phonesAreValidUsers[p] != null) {
        user = this._phonesAreValidUsers[p];
        break;
      }
    }

    return user;
  }

  Future<void> didAddUserWithPhones(List<String> phones) async {
    final user = this._getValidUserForPhones(phones);
    if (user != null) {
      await this._addUserAsFriend(user.id);

      await this.getCurrentUserFriends();
    }
  }

  Future<void> getCurrentUserFriends() async {
    this._setIsFetching(true);
    final list = await this._getUserFriends(this.currentUserId);
    this._setCurrentUserFriends(list);
    this._setIsFetching(false);
  }

  Future<void> requestContacts() async {
    this._setIsFetchingContacts(true);
    final list = await this._getUserContacts();

    this._setUserContactsList(list);
    this._setIsFetchingContacts(false);
  }

  Future<void> verifyPhonesAreValidUsers() async {
    if (this.contactsPhones.isEmpty) {
      return;
    }

    final result = await this._thereAreValidUsersForPhones(this.contactsPhones);
    this._setPhonesAreValidUsers(result);
  }

  Future<void> _verifyContactPermissionStatus() async {
    final status = await this._verifyPermissionStatus();
    this._setPermissionStatus(status);
  }

  Future<void> requestContactPermission() async {
    final status = await this._requestPermission();
    this._setPermissionStatus(status);
  }

  void _openUrl(String url) {
    final encodedUrl = Uri.encodeFull(url);
    tryToOpenUrl(encodedUrl);
  }

  void inviteContactByWhatsApp(String phone) {
    this._openUrl(
      "whatsapp://send?phone=${phone.replaceAll("+", "")}&text=$INVITE_MESSAGE",
    );
  }

  void inviteContactByEmail(String email) {
    this._openUrl(
      "mailto:$email?subject=$INVITE_MESSAGE",
    );
  }
}
