enum APP_ROUTE {
  LOGIN,
  HOME,
  BOOK,
  BOOK_DETAIL,
  BOOK_FORM,
  BOOK_REVIEW,
  REQUEST_LOAN,
  PROFILE_FORM,
  CONFIRM_LOAN,
  GENERAL,
  USER,
  USER_PROFILE,
}

extension AppRouteExtension on APP_ROUTE {
  bool get isMainRoute => [
        APP_ROUTE.LOGIN,
        APP_ROUTE.HOME,
        APP_ROUTE.GENERAL,
      ].contains(this);

  String get path {
    switch (this) {
      case APP_ROUTE.LOGIN:
        return "/login";

      case APP_ROUTE.BOOK:
        return "/book";

      case APP_ROUTE.BOOK_DETAIL:
        return "/book/view/:id";

      case APP_ROUTE.BOOK_FORM:
        return "/book/form/:id";
      case APP_ROUTE.BOOK_REVIEW:
        return "/book/review/:id";

      case APP_ROUTE.REQUEST_LOAN:
        return "/book/loan/:id";

      case APP_ROUTE.CONFIRM_LOAN:
        return "/book/confirm-loan/:id";

      case APP_ROUTE.USER:
        return "/user";
      case APP_ROUTE.USER_PROFILE:
        return "/user/profile/:id";

      case APP_ROUTE.PROFILE_FORM:
        return "/profile-form";

      case APP_ROUTE.GENERAL:
        return "/general";

      case APP_ROUTE.HOME:
      default:
        return "/";
    }
  }

  String get pathForModule {
    switch (this) {
      case APP_ROUTE.BOOK_DETAIL:
        return "/view/:id";
      case APP_ROUTE.BOOK_FORM:
        return "/form/:id";
      case APP_ROUTE.BOOK_REVIEW:
        return "/review/:id";
      case APP_ROUTE.REQUEST_LOAN:
        return "/loan/:id";
      case APP_ROUTE.CONFIRM_LOAN:
        return "/confirm-loan/:id";

      case APP_ROUTE.USER_PROFILE:
        return "/profile/:id";

      case APP_ROUTE.LOGIN:
      case APP_ROUTE.HOME:
      case APP_ROUTE.USER:
      default:
        return "/";
    }
  }

  String pathWithId(String id) => this.path.replaceAll(":id", id);
}
