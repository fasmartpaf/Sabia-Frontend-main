import 'package:flutter_modular/flutter_modular.dart';
import './pages/login_page/login_page.dart';
import '../../routes/app_routes.dart';

class LoginModule extends ChildModule {
  static Inject get to => Inject<LoginModule>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(APP_ROUTE.LOGIN.pathForModule,
            child: (_, args) => LoginPage()),
      ];
}
