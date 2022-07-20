import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/services/payments_with_stores_service.dart';

import './pages/home_page.dart';
import './pages/profile_form_page/profile_form_page.dart';
import './services/dio_client_http_service.dart';
import './services/sabia_api_service.dart';

import './routes/app_routes.dart';
import './services/firebase_service.dart';
import './services/notifications_service.dart';
import './services/contacts_service.dart';
import './stores/main_store.dart';
import './modules/login_module/login_module.dart';

import './app.dart';
import './modules/book_module/book_module.dart';
import './modules/user/user_module.dart';
import './services/firebase_images_service.dart';
import './interfaces/images_service_interface.dart';
import './interfaces/crash_report_service_interface.dart';
import './services/crashlytics_service.dart';
import 'services/user_permission_service.dart';

class AppModule extends MainModule {
  final bool isProductionServer;

  AppModule({
    this.isProductionServer = false,
  });

  @override
  List<Bind> get binds => [
        Bind((i) => i.get<MainStore>().authStore),
        Bind((i) => i.get<MainStore>().bookLoanStore),
        Bind((i) => i.get<MainStore>().bookStore),
        Bind((i) => i.get<MainStore>().analyticsStore),
        Bind((i) => i.get<MainStore>().notificationsStore),
        Bind((i) => i.get<MainStore>().settingsStore),
        Bind((i) => i.get<MainStore>().routingStore),
        Bind((i) => i.get<MainStore>().feedStore),
        Bind((i) => i.get<MainStore>().userStore),
        Bind((i) => MainStore(
              i.get<FirebaseAnalytics>(),
              i.get<FirebaseService>(),
              i.get<CrashReportServiceInterface>(),
              i.get<ImagesServiceInterface>(),
              i.get<SabiaApiService>(),
              i.get<UserPermissionService>(),
            )),
        Bind((i) => SabiaApiService(
              DioClientHttpService(),
              i.get<CrashReportServiceInterface>(),
              isProductionServer: this.isProductionServer,
            )),
        Bind((i) => FirebaseImagesService(i.get<FirebaseService>())),
        Bind((i) => CrashlyticsService()),
        Bind((i) => FirebaseService()),
        Bind((i) => UserPermissionService()),
        Bind((i) => ContactsServiceImplementation()),
        Bind((i) => NotificationsService()),
        Bind((i) => FirebaseAnalytics()),
        Bind((i) => InAppPurchaseClass())
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          APP_ROUTE.LOGIN.path,
          module: LoginModule(),
        ),
        ModularRouter(
          APP_ROUTE.BOOK.path,
          module: BookModule(),
        ),
        ModularRouter(
          APP_ROUTE.USER.path,
          module: UserModule(),
        ),
        ModularRouter(
          APP_ROUTE.PROFILE_FORM.path,
          child: (_, args) => ProfileFormPage(),
        ),
        ModularRouter(
          APP_ROUTE.HOME.path,
          child: (_, args) => HomePage(),
        ),
        ModularRouter(
          APP_ROUTE.GENERAL.path,
          child: (_, args) => args.data,
        )
      ];

  @override
  Widget get bootstrap => App(
        isProductionServer: isProductionServer,
      );
}
