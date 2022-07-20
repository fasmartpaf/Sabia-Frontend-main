import 'package:flutter/foundation.dart';

abstract class CrashReportServiceInterface {
  Future<void> setUserData(
    String userId, {
    String email,
    String name,
  });

  Future<void> setValue(
    dynamic value, {
    @required String key,
  });

  void logMessage(String message);
}
