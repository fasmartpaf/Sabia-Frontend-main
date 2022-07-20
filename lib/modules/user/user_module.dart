import 'package:flutter_modular/flutter_modular.dart';
import '../../stores/auth_store.dart';
import '../../routes/app_routes.dart';

import './pages/user_profile_page.dart';

class UserModule extends ChildModule {
  final void Function(int index) onChangeHomePageIndex;

  UserModule({this.onChangeHomePageIndex});

  static Inject get to => Inject<UserModule>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          Modular.initialRoute,
          child: (_, args) => UserProfilePage(
            Modular.get<AuthStore>().uid,
            onChangeHomePageIndex: onChangeHomePageIndex,
          ),
        ),
        ModularRouter(
          APP_ROUTE.USER_PROFILE.pathForModule,
          child: (_, args) => UserProfilePage(
            args.params["id"],
            displayContact:
                args.data != null ? args.data["displayContact"] : false,
            predefinedMessage:
                args.data != null ? args.data["predefinedMessage"] : "",
          ),
        ),
      ];
}
