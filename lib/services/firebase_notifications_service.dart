import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../utils/debounce.dart';

class FirebaseNotificationsService {
  final void Function(Map<String, dynamic>) onMessage;
  final void Function(Map<String, dynamic>) onResume;
  final void Function(Map<String, dynamic>) onLaunch;
  final void Function(String) onRefreshToken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String currentToken = "";

  FirebaseNotificationsService({
    this.onMessage,
    this.onResume,
    this.onLaunch,
    this.onRefreshToken,
  }) {
    _configure();
  }

  _onRefreshToken(String newToken) {
    if (newToken != this.currentToken) {
      this.currentToken = newToken;
      Debounce.run(
        () => this.onRefreshToken(newToken),
      );
    }
  }

  void _configure() {
    _firebaseMessaging.getToken().then((String token) {
      this._onRefreshToken(token);
    });

    _firebaseMessaging.onTokenRefresh.listen((String token) {
      this._onRefreshToken(token);
      debugPrint("fcm onTokenRefresh $token");
    });

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      debugPrint("onMessage $message");
      this.onMessage(message);
    }, onResume: (Map<String, dynamic> message) async {
      debugPrint("onResume $message");
      this.onResume(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      debugPrint("onLaunch $message");
      this.onLaunch(message);
    });
  }

  void requestiOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      debugPrint("Settings registered: $settings");
    });
  }

  requestPermission() {
    if (Platform.isIOS) requestiOSPermission();
  }
}
