import 'package:flutter_test/flutter_test.dart';
import 'package:sabia_app/model/contact_model.dart';
import 'package:sabia_app/model/user_model.dart';
import 'package:sabia_app/modules/friends_module/store/friends_page_store.dart';
import 'package:sabia_app/services/user_permission_service.dart';
import 'package:sabia_app/utils/delayed.dart';

void main() {
  group('FriendsPageStore tests', () {
    test("initial values", () {
      final userId = "f3a20635-ce4b-4f7d-b6cd-3031c0a3f441";
      final sut = createSUT(currentUserId: userId);

      expect(sut.currentUserId, userId);
      expect(sut.permissionStatus, EPermissionStatus.undetermined);
      expect(sut.isFetching, false);
      expect(sut.searchString, "");
    });

    test("getCurrentUserFriends should use isFetching", () {
      final sut = createSUT();
      sut.getCurrentUserFriends();
      expect(sut.isFetching, true);
    });
    test("getCurrentUserFriends should be called", () async {
      int calledCount = 0;
      Future<List<UserModel>> getUserFriends(String userId) async {
        calledCount++;
        return [];
      }

      final sut = createSUT(getUserFriends: getUserFriends);
      await sut.getCurrentUserFriends();
      await sut.getCurrentUserFriends();

      expect(calledCount, 2);
    });
    test("currentUserFriends should have user", () async {
      Future<List<UserModel>> getUserFriends(String userId) async {
        return [user1, user2];
      }

      final sut = createSUT(getUserFriends: getUserFriends);
      await sut.getCurrentUserFriends();

      expect(sut.currentUserFriends.length, 2);
      expect(sut.currentUserFriends.first.name, user1.name);
      expect(sut.currentUserFriends.last.name, user2.name);
    });

    test("requestContacts should use isFetchingContacts", () {
      final sut = createSUT();
      sut.requestContacts();
      expect(sut.isFetchingContacts, true);
    });
    test("requestContacts should be called", () async {
      int calledCount = 0;
      Future<List<ContactModel>> getUserContacts() async {
        calledCount++;
        return [];
      }

      final sut = createSUT(getUserContacts: getUserContacts);
      await sut.requestContacts();
      await sut.requestContacts();

      expect(calledCount, 2);
    });
    test("currentUserFriends should have user", () async {
      Future<List<ContactModel>> getUserContacts() async {
        return [contact1, contact2];
      }

      final sut = createSUT(getUserContacts: getUserContacts);
      await sut.requestContacts();

      expect(sut.userContactsList.length, 2);
      expect(sut.userContactsList.first.name, contact1.name);
      expect(sut.userContactsList.last.name, contact2.name);
    });

    test("should verify permission status", () async {
      final sut1 = createSUT(
        verifyPermissionStatus: () async => EPermissionStatus.denied,
      );
      final sut2 = createSUT(
        verifyPermissionStatus: () async => EPermissionStatus.granted,
      );
      // Delay to let store update the observable property
      await delayFor(milliseconds: 100);

      expect(sut1.permissionStatus, EPermissionStatus.denied);
      expect(sut2.permissionStatus, EPermissionStatus.granted);
    });
    test("should request permission", () async {
      int calledCount = 0;
      Future<EPermissionStatus> requestPermission() async {
        calledCount++;
        if (calledCount <= 1) {
          return EPermissionStatus.denied;
        }
        return EPermissionStatus.granted;
      }

      final sut = createSUT(requestPermission: requestPermission);

      await sut.requestContactPermission();
      expect(calledCount, 1);
      expect(sut.permissionStatus, EPermissionStatus.denied);

      await sut.requestContactPermission();
      expect(calledCount, 2);
      expect(sut.permissionStatus, EPermissionStatus.granted);
    });
  });
}

// Helpers
final user1 = UserModel(
  id: "user1",
  name: "Gilda Alexys",
  phone: "5511888881234",
  email: "gilda.alexys@email.com",
);
final user2 = UserModel(
  id: "user1",
  name: "Dawn Crona",
  phone: "5511998881234",
  email: "dawn.crona@email.com",
);

final contact1 = ContactModel(
  name: "Gilda Alexys",
  emails: ["gilda.alexys@email.com"],
  phones: ["5511888881234"],
);
final contact2 = ContactModel(
  name: "Dawn Crona",
  emails: ["dawn.crona@email.com"],
  phones: ["5511998881234"],
);

FriendsPageStore createSUT({
  String currentUserId = "4ccaff58-9f32-46b2-be62-2f42fc77b9e5",
  Future<EPermissionStatus> Function() verifyPermissionStatus,
  Future<EPermissionStatus> Function() requestPermission,
  Future<List<UserModel>> Function(String userId) getUserFriends,
  Future<Map<String, UserModel>> Function(List<String> phones)
      thereAreValidUsersForPhones,
  Future<List<ContactModel>> Function() getUserContacts,
  Future<void> Function(String userId) addUserAsFriend,
}) {
  Future<EPermissionStatus> defaultVerifyPermissionStatus() async {
    return EPermissionStatus.undetermined;
  }

  Future<EPermissionStatus> defaultRequestPermission() async {
    return EPermissionStatus.undetermined;
  }

  Future<List<UserModel>> defaultGetUserFriends(String userId) async {
    return [user1, user2];
  }

  Future<Map<String, UserModel>> defaultThereAreValidUsersForPhones(
      List<String> phones) async {
    return {};
  }

  Future<List<ContactModel>> defaultGetContacts() async {
    return [contact1, contact2];
  }

  return FriendsPageStore(
    currentUserId,
    verifyPermissionStatus ?? defaultVerifyPermissionStatus,
    requestPermission ?? defaultRequestPermission,
    getUserFriends ?? defaultGetUserFriends,
    thereAreValidUsersForPhones ?? defaultThereAreValidUsersForPhones,
    getUserContacts ?? defaultGetContacts,
    addUserAsFriend ?? () => Future.value(),
  );
}
