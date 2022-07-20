import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabia_app/services/user_permission_service.dart';
import '../modules/feed_module/store/feed_store.dart';

import '../interfaces/crash_report_service_interface.dart';
import '../interfaces/images_service_interface.dart';
import '../services/sabia_api_service.dart';
import '../stores/book_loan_store.dart';
import '../stores/user_store.dart';
import '../stores/routing_store.dart';
import '../services/firebase_notifications_service.dart';
import '../services/firebase_service.dart';
import '../services/notifications_service.dart';

import './analytics_store.dart';
import "./auth_store.dart";
import './settings_store.dart';
import 'book_store.dart';
import 'notifications_store.dart';

class MainStore {
  AuthStore authStore;
  BookStore bookStore;
  NotificationsStore notificationsStore;
  AnalyticsStore analyticsStore;
  FirebaseService firebaseService;
  ImagesServiceInterface imagesService;
  CrashReportServiceInterface crashReportService;
  SabiaApiService sabiaApiService;
  UserPermissionService _userPermissionService;
  RoutingStore routingStore;
  FeedStore feedStore;
  UserStore userStore;
  SettingsStore settingsStore;
  BookLoanStore bookLoanStore;

  NotificationsService notificationsService = NotificationsService();

  MainStore(
    FirebaseAnalytics firebaseAnalytics,
    this.firebaseService,
    this.crashReportService,
    this.imagesService,
    this.sabiaApiService,
    this._userPermissionService,
  ) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    FirebaseNotificationsService(
      onMessage: _firebaseNotificationsOnMessageCallback,
      onResume: _firebaseNotificationsOnResumeCallback,
      onLaunch: _firebaseNotificationsOnLaunchCallback,
      onRefreshToken: _getDeviceFCMToken,
    );

    // Set Stores
    this.settingsStore = SettingsStore(_userPermissionService);
    this.analyticsStore = AnalyticsStore(firebaseAnalytics);
    this.routingStore = RoutingStore();

    this.authStore = AuthStore(
      this.analyticsStore,
      this.routingStore,
      firebaseAuth,
      this.sabiaApiService,
      this.firebaseService,
      this.crashReportService,
      this.imagesService,
      notificationsService,
    );

    this.bookStore = BookStore(
      this.authStore,
      this.analyticsStore,
      this.routingStore,
      this.firebaseService,
      this.imagesService,
      this.notificationsService,
      this.sabiaApiService,
    );

    this.bookLoanStore = BookLoanStore(
      this.authStore,
      this.bookStore,
      this.routingStore,
      this.sabiaApiService,
      this.firebaseService,
      this.imagesService,
      this.notificationsService,
    );

    this.notificationsStore = NotificationsStore(
      this.authStore,
      this.bookLoanStore,
      this.firebaseService,
    );

    this.feedStore = FeedStore(
      this.authStore,
      this.bookStore,
      this.sabiaApiService,
      this.imagesService,
    );

    this.userStore = UserStore(
      this.authStore,
      this.bookStore,
      this.firebaseService,
      this.sabiaApiService,
      this.imagesService,
    );

    // Set stores on Services who need it
    this.sabiaApiService.setStores(this.authStore);
  }

  Map<String, String> _handleNotification(Map<String, dynamic> notification) {
    String title = "", message = "", bookId = "";

    if (Platform.isIOS) {
      if (notification.containsKey("aps") &&
          notification["aps"]["alert"] != null) {
        final Map<String, dynamic> alert = notification["aps"]["alert"];
        title = alert["title"];
        message = alert["body"];
      }
      bookId = notification["bookId"] != null ? notification["bookId"] : "";
    } else {
      if (notification.containsKey("notification")) {
        final Map<String, dynamic> map = notification["notification"];
        title = map["title"];
        message = map["body"];
      }
      if (notification.containsKey("data")) {
        bookId = notification["data"]["bookId"] ?? "";
      }
    }

    return {
      "title": title,
      "message": message,
      "bookId": bookId,
    };
  }

  _firebaseNotificationsOnMessageCallback(Map<String, dynamic> notification) {
    final result = _handleNotification(notification);
    final String title = result["title"];
    final String message = result["message"];

    if (title.isNotEmpty || message.isNotEmpty) {
      // TODO: handle notification
    }
  }

  _firebaseNotificationsOnResumeCallback(Map<String, dynamic> notification) {
    // final result = _handleNotification(notification);

    // handle notification on resume
  }

  _firebaseNotificationsOnLaunchCallback(Map<String, dynamic> notification) {
    // final result = _handleNotification(notification);
    // handle notification on background
  }

  _getDeviceFCMToken(String token) {
    if (token == this.authStore.currentNotificationToken) return;
    this.authStore.setCurrentNotificationToken(token);
  }
}
