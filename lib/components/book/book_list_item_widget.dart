import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/components/user/user_feed_widget.dart';
import 'package:sabia_app/model/book/book_loan_model.dart';

import '../../stores/book_store.dart';
import '../../stores/book_loan_store.dart';
import '../../model/book/book_model.dart';
import '../../model/user_model.dart';
import 'book_status_widget.dart';
import 'book_image_widget.dart';

class BookListItemWidget extends StatelessWidget {
  final BookModel book;
  final UserModel user;
  final Function onTap;

  const BookListItemWidget(
    this.book, {
    this.onTap,
    this.user,
    Key key,
  }) : super(key: key);

  String _getBorrowedBookStatusLabel(
    BookLoanModel _bookLoan,
  ) {
    if (_bookLoan.status == BookLoanStatus.requested) {
      return "Pedi emprestado, aguardando resposta";
    } else if (_bookLoan.status == BookLoanStatus.toDelivery) {
      return "Ele vai me emprestar!\nVou combinar para pega-lo!";
    } else if (_bookLoan.status == BookLoanStatus.lend) {
      return "Está comigo em empréstimo";
    } else if (_bookLoan.status == BookLoanStatus.toReturn) {
      return "Preciso devolver!";
    }
    return null;
  }

  String _getLoanedBookStatusLabel(
    BookLoanModel _bookLoan,
  ) {
    if (_bookLoan.status == BookLoanStatus.requested) {
      return "Pediram emprestado,\naguardando sua resposta!";
    } else if (_bookLoan.status == BookLoanStatus.toDelivery) {
      return "Aceitei empresta-lo.\nVou combinar a entrega!";
    } else if (_bookLoan.status == BookLoanStatus.lend) {
      return "Está emprestado";
    } else if (_bookLoan.status == BookLoanStatus.toReturn) {
      return "Empréstimo acabou, o leitor precisa me devolver!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final _bookStore = Modular.get<BookStore>();
    final _bookLoanStore = Modular.get<BookLoanStore>();

    final borrowedBookLoan =
        _bookLoanStore.getBorrowedBookLoanOfBookIfExists(book.id);
    final borrowedThisBook = borrowedBookLoan != null;
    final bookBorrowedStatusLabel =
        borrowedThisBook ? _getBorrowedBookStatusLabel(borrowedBookLoan) : null;

    final loanedBookLoan =
        _bookLoanStore.getLoanedBookLoanOfBookIfExists(book.id);
    final loanedThisBook = loanedBookLoan != null;

    final bookLoanStatusLabel =
        loanedThisBook ? _getLoanedBookStatusLabel(loanedBookLoan) : null;

    return Observer(
      builder: (_) {
        return Card(
          child: ListTile(
            visualDensity: VisualDensity.compact,
            trailing: BookImageWidget(
              imageUrl: book.coverUrl,
              alt: book.title,
              onErrorBookCoverUrl: (_) => _bookStore.onErrorBookCoverUrl(book),
            ),
            title: Text(
              book.title,
              style: textTheme.subtitle1.copyWith(
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.authors?.isNotEmpty ?? false) ...[
                  Text(
                    book.authors.join(", "),
                    style: textTheme.subtitle2.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 6),
                ],
                BookStatusWidget(
                  book.status,
                  customStatus: bookBorrowedStatusLabel != null
                      ? bookBorrowedStatusLabel
                      : bookLoanStatusLabel,
                ),
                if (user != null ||
                    bookBorrowedStatusLabel != null ||
                    bookLoanStatusLabel != null)
                  SizedBox(height: 4),
                if (user != null)
                  UserFeedWidget(book.user)
                else if (bookLoanStatusLabel != null)
                  UserFeedWidget(loanedBookLoan.toUser),
              ],
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
