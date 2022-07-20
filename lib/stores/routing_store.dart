import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/routes/app_routes.dart';

class RoutingStore {
  APP_ROUTE _findRouteByPath(String routePath) {
    if (routePath.contains("/book/view/")) {
      return APP_ROUTE.BOOK_DETAIL;
    } else if (routePath.contains("/book/form/")) {
      return APP_ROUTE.BOOK_FORM;
    } else if (routePath.contains("/book/form/")) {
      return APP_ROUTE.BOOK_REVIEW;
    } else if (routePath.contains("/book/review/")) {
      return APP_ROUTE.REQUEST_LOAN;
    } else if (routePath.contains("/book/confirm-loan/")) {
      return APP_ROUTE.CONFIRM_LOAN;
    } else if (routePath.contains("/user/profile/")) {
      return APP_ROUTE.USER_PROFILE;
    }

    switch (routePath) {
      case "/book":
        return APP_ROUTE.BOOK;
      case "/profile-form":
        return APP_ROUTE.PROFILE_FORM;
      case "/login":
        return APP_ROUTE.LOGIN;
      case "/general":
        return APP_ROUTE.GENERAL;
      case "/":
      default:
        return APP_ROUTE.HOME;
    }
  }

  APP_ROUTE get currentRoute {
    final path = Modular.to.path;

    return this._findRouteByPath(path);
  }

  void moveToMainRoute(
    String routePath, {
    Object arguments,
  }) {
    if (routePath == null || routePath.isEmpty) return;
    Modular.to.pushNamedAndRemoveUntil(
      routePath,
      (route) => false,
      arguments: arguments,
    );
  }

  void moveToRoute(
    String routePath, {
    Object arguments,
  }) {
    if (routePath == null || routePath.isEmpty) return;
    Modular.to.pushNamed(
      routePath,
      arguments: arguments,
    );
  }

  void replaceToRoute(
    String routePath, {
    Object arguments,
  }) {
    if (routePath == null || routePath.isEmpty) return;
    Modular.to.pushReplacementNamed(
      routePath,
      arguments: arguments,
    );
  }

  void backRoute() {
    Modular.to.pop();
  }

  void moveToGeneralRoute(Object arguments) {
    this.moveToRoute(
      APP_ROUTE.GENERAL.path,
      arguments: arguments,
    );
  }

  void replaceToGeneralRoute(Object arguments) {
    this.replaceToRoute(
      APP_ROUTE.GENERAL.path,
      arguments: arguments,
    );
  }
}
