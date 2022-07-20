import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import "./app_module.dart";

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  debugPrint = (String message, {int wrapWidth}) => debugPrintSynchronously(
        "[${DateTime.now()}]: $message",
        wrapWidth: wrapWidth,
      );

  FlutterError.onError = (FlutterErrorDetails details) {
    // In development mode simply print to console.
    FlutterError.dumpErrorToConsole(details);
  };

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(module: AppModule()),
  );
}
