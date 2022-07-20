import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/services/contacts_service.dart';
import 'package:sabia_app/services/user_permission_service.dart';
import 'package:sabia_app/stores/auth_store.dart';
import 'package:sabia_app/stores/user_store.dart';

import './pages/friends_page.dart';
import 'store/friends_page_store.dart';

class FriendsModule extends ChildModule {
  static Inject get to => Inject<FriendsModule>.of();

  Future<EPermissionStatus> defaultRequestPermissionStatus() async {
    return EPermissionStatus.undetermined;
  }

  @override
  List<Bind> get binds => [
        Bind((i) {
          final permissionService = i.get<UserPermissionService>();
          return FriendsPageStore(
            i.get<AuthStore>().uid,
            () => permissionService.check(PermissionType.contacts),
            () async {
              final status =
                  await permissionService.check(PermissionType.contacts);
              if (status == EPermissionStatus.denied) {
                await permissionService.openSettings();
                return EPermissionStatus.denied;
              } else {
                return permissionService.request(PermissionType.contacts);
              }
            },
            (String userId) => i.get<UserStore>().getCurrentUserFriendsData(),
            i.get<UserStore>().thereAreValidUsersForPhones,
            i.get<ContactsService>().getContacts,
            i.get<UserStore>().didAddUserAsFriend,
          );
        }),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          Modular.initialRoute,
          child: (_, args) => FriendsPage(),
        ),
      ];
}
