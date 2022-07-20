import 'package:flutter_modular/flutter_modular.dart';
import '../../stores/auth_store.dart';
import '../../routes/app_routes.dart';

import './pages/user_library_page.dart';

class UserLibraryModule extends ChildModule {
  static Inject get to => Inject<UserLibraryModule>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          Modular.initialRoute,
          child: (_, args) => UserLibraryPage(
            Modular.get<AuthStore>().uid,
          ),
        ),
        ModularRouter(
          APP_ROUTE.USER_PROFILE.pathForModule,
          child: (_, args) => UserLibraryPage(
            args.params["id"],
          ),
        ),
      ];
}
