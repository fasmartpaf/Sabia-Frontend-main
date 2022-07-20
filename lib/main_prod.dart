import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import "./app_module.dart";

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  debugPrint = (String message, {int wrapWidth}) {};

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(
      module: AppModule(isProductionServer: true),
    ),
  );
}
