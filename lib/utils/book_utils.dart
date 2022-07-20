import 'package:sabia_app/model/book/book_loan_model.dart';
import 'package:sabia_app/model/book/book_model.dart';

List<BookModel> sortBooksListWithBookLoan(
  BookLoanModel Function(String id) searchBookLoanFn,
  List<BookModel> listToSort,
) {
  final list = [...listToSort];
  list.sort((BookModel a, BookModel b) {
    final aBookLoan = searchBookLoanFn(a.id);
    final bBookLoan = searchBookLoanFn(b.id);

    if (bBookLoan != null) {
      if (aBookLoan != null) {
        final aStatus = aBookLoan.status;
        final bStatus = bBookLoan.status;
        if (aStatus == bStatus) return 0;
        if (aStatus == BookLoanStatus.toReturn) {
          return -1;
        }
        if (bStatus == BookLoanStatus.toReturn) {
          return 1;
        }
        if (aStatus == BookLoanStatus.toDelivery) {
          return -1;
        }
        if (bStatus == BookLoanStatus.toDelivery) {
          return 1;
        }
        if (aStatus == BookLoanStatus.requested) {
          return -1;
        }
        if (bStatus == BookLoanStatus.requested) {
          return 1;
        }
        return 0;
      }
      return 1;
    }
    if (aBookLoan != null) {
      return -1;
    }
    return 0;
  });

  return list;
}
