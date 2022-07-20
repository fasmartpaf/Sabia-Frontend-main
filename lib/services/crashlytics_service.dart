import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import "../interfaces/crash_report_service_interface.dart";

class CrashlyticsService implements CrashReportServiceInterface {
  @override
  Future<void> setUserData(
    String userId, {
    String email,
    String name,
  }) async {
    final crashlytics = Crashlytics.instance;
    await crashlytics.setUserIdentifier(userId);
    if (email != null && email.isNotEmpty) {
      await crashlytics.setUserEmail(email);
    }
    if (name != null && name.isNotEmpty) {
      await crashlytics.setUserName(name);
    }
  }

  @override
  Future<void> setValue(
    dynamic value, {
    @required String key,
  }) async {
    final crashlytics = Crashlytics.instance;

    if (value is String) {
      crashlytics.setString(key, value);
    } else if (value is bool) {
      crashlytics.setBool(key, value);
    } else if (value is int) {
      crashlytics.setInt(key, value);
    } else if (value is double) {
      crashlytics.setDouble(key, value);
    }
  }

  @override
  void logMessage(String message) {
    Crashlytics.instance.log(message);
  }
}
