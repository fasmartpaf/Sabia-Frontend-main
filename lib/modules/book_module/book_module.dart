import 'package:flutter_modular/flutter_modular.dart';
import '../../routes/app_routes.dart';
import './pages/book_confirm_loan_page.dart';
import './pages/book_details_page.dart';
import './pages/book_form_page/book_form_page.dart';
import './pages/book_review_page.dart';
import './pages/book_request_loan_page.dart';

class BookModule extends ChildModule {
  static Inject get to => Inject<BookModule>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          APP_ROUTE.BOOK_DETAIL.pathForModule,
          child: (_, args) => BookDetailsPage(),
        ),
        ModularRouter(
          APP_ROUTE.BOOK_FORM.pathForModule,
          child: (_, args) => BookFormPage(),
        ),
        ModularRouter(
          APP_ROUTE.BOOK_REVIEW.pathForModule,
          child: (_, args) => BookReviewPage(
            args.data["book"],
            rating: args.data["rating"],
          ),
        ),
        ModularRouter(
          APP_ROUTE.REQUEST_LOAN.pathForModule,
          child: (_, args) => BookRequestLoanPage(),
        ),
        ModularRouter(
          APP_ROUTE.CONFIRM_LOAN.pathForModule,
          child: (_, args) => BookConfirmLoanPage(),
        ),
      ];
}
