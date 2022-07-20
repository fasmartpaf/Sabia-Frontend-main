import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../components/book/book_action_display.dart';
import '../../../components/book/book_days_to_loan_widget.dart';
import '../../../components/button/button.dart';
import '../../../components/button/submit_button.dart';
import '../../../components/loading/loading_view.dart';
import '../../../components/scaffold/no_pop_scaffold.dart';
import '../../../stores/book_loan_store.dart';

import '../../../extensions/int_extension.dart';

class BookConfirmLoanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bookLoanStore = Modular.get<BookLoanStore>();

    return NoPopScaffold(
      title: "Confirmação",
      child: Observer(
        builder: (_) {
          if (_bookLoanStore.selectedBookLoan == null ||
              _bookLoanStore.isFetchingRelatedRecords) {
            return LoadingView();
          }

          final relatedRecords = _bookLoanStore.relatedBookLoanRecords;

          final requestedLoansQuantity = relatedRecords.length + 1;

          String actionLabel = requestedLoansQuantity.i18nPlural(
            "relatedRecordsLengthActionLabel",
            one: "Uma pessoa está interessada no seu livro",
            other: "# pessoas estão interessadas no seu livro",
          );

          return Column(
            children: <Widget>[
              Expanded(
                child: Observer(
                  builder: (_) => BookActionDisplay(
                    _bookLoanStore.selectedBookLoan.book,
                    toUserList: [
                      _bookLoanStore.selectedBookLoan.toUser,
                      ...relatedRecords.map((loan) => loan.toUser).toList(),
                    ],
                    actionLabel: actionLabel,
                  ),
                ),
              ),
              SafeArea(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Button(
                        label: "NEGAR",
                        padding: EdgeInsets.all(20),
                        outlined: true,
                        fullWidth: true,
                        square: true,
                        onPressed: () => _bookLoanStore
                            .didRejectLoan(_bookLoanStore.selectedBookLoan),
                      ),
                    ),
                    Expanded(
                      child: SubmitButton(
                        label: "EMPRESTAR",
                        onPressed: () => BookDaysToLoanModal.open(
                          context,
                          _bookLoanStore,
                          _bookLoanStore.selectedBookLoan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
