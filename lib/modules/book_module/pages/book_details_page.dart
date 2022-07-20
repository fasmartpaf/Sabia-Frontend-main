import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../components/book/book_days_to_loan_widget.dart';
import '../../../components/icon/app_icon.dart';
import '../../../components/modal/modal.dart';
import '../../../components/pagination/page_view_widget.dart';
import '../../../components/user/user_feed_widget.dart';
import '../../../components/book/book_item_widget.dart';
import '../../../components/book/book_review_widget.dart';
import '../../../components/button/button.dart';
import '../../../components/button/submit_button.dart';
import '../../../components/loading/loading_view.dart';
import '../../../components/modal/book_collect_rating_modal.dart';
import '../../../components/scaffold/will_pop_scaffold.dart';
import '../../../components/text/section_title.dart';

import '../../../model/book/book_loan_model.dart';

import '../../../stores/book_loan_store.dart';
import '../../../stores/auth_store.dart';
import '../../../stores/book_store.dart';

import '../../../utils/styles.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({Key key}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  final BookStore _bookStore = Modular.get<BookStore>();
  final BookLoanStore _bookLoanStore = Modular.get<BookLoanStore>();

  bool _isWaiting = false;

  _enableIsWaiting() => setState(() => this._isWaiting = true);
  _disableIsWaiting() => setState(() => this._isWaiting = false);

  List<Widget> _renderDescription(String description) {
    if (description == null || description.isEmpty) {
      return [];
    }
    return [
      Divider(height: 26),
      SectionTitle("Sinopse"),
      SizedBox(height: 12),
      Text(
        description,
        maxLines: null,
      ),
    ];
  }

  List<Widget> renderLoanedBookWidgets(
    BookLoanModel _bookLoan,
  ) {
    final textTheme = Theme.of(context).textTheme;
    if (_bookLoan.status == BookLoanStatus.toDelivery) {
      if (_bookLoan.toDeliveryOwnerAnswer) {
        return [
          Text(
            "Você informou que já entregou o livro para o leitor. Estamos confirmando com ele o recebimento.",
          ),
        ];
      }
      return [
        Text(
          "Você aceitou emprestar este livro.\nCombine a entrega dele com o leitor:",
        ),
        SizedBox(height: 10),
        UserFeedWidget(_bookLoan.toUser),
        SizedBox(height: 10),
        Button(
          outlined: true,
          fullWidth: true,
          label: "Já entreguei para o leitor",
          onPressed: () {
            Modal.confirm(
              message:
                  "Você realmente confirma que entregou o livro para o leitor?",
              onConfirm: () async {
                this._enableIsWaiting();
                await _bookLoanStore.ownerSaidHeAlreadyDelivered(_bookLoan);
                this._disableIsWaiting();
              },
            );
          },
        ),
      ];
    }
    if (_bookLoan.status == BookLoanStatus.requested) {
      final requests =
          _bookLoanStore.getAllRequestBookLoansForBook(_bookLoan.book.id);

      List<Widget> requestsChildren = [];
      for (var request in requests) {
        requestsChildren.add(
          Card(
            margin: EdgeInsets.only(
              right: requests.length > 1 ? 20 : 0,
              top: 4,
              bottom: 8,
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserFeedWidget(
                    request.toUser,
                    alignCenter: true,
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        type: ButtonType.danger,
                        label: "Negar",
                        outlined: true,
                        small: true,
                        onPressed: () => _bookLoanStore.didRejectLoan(
                          request,
                          shouldRedirect: false,
                        ),
                      ),
                      Button(
                        type: ButtonType.success,
                        label: "Aceitar",
                        small: true,
                        onPressed: () => BookDaysToLoanModal.open(
                          context,
                          _bookLoanStore,
                          request,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return [
        Row(
          children: [
            Expanded(
              child: Text(
                requestsChildren.length > 1
                    ? "${requestsChildren.length} pessoas pediram emprestado:"
                    : "Pediu emprestado:",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (requestsChildren.length > 1)
          PageViewWidget(
            items: requestsChildren,
            viewportFraction: 0.9,
          )
        else
          requestsChildren[0],
      ];
    }
    if (_bookLoan.status == BookLoanStatus.lend) {
      return [
        RichText(
          text: TextSpan(
            text: "Emprestado para o leitor até ",
            style: textTheme.bodyText1,
            children: [
              TextSpan(
                text: _bookLoan.expireDate,
                children: [
                  TextSpan(
                    text: ":",
                    style: textTheme.bodyText1,
                  ),
                ],
                style: TextStyle(
                  color: kSuccessColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        UserFeedWidget(_bookLoan.toUser),
      ];
    }
    return [
      Text(_bookLoan.status.labelFrom),
      SizedBox(height: 8),
      UserFeedWidget(_bookLoan.toUser),
      if (_bookLoan.status == BookLoanStatus.toReturn)
        Button(
          outlined: true,
          label: "O livro já foi devolvido",
          fullWidth: true,
          onPressed: () {
            Modal.confirm(
              message:
                  "Você realmente confirma que o leitor já te devolveu o livro?",
              onConfirm: () async {
                this._enableIsWaiting();
                await _bookLoanStore.ownerAnticipatedReturn(_bookLoan);
                this._disableIsWaiting();
              },
            );
          },
        ),
    ];
  }

  List<Widget> renderBorrowedBookWidgets(
    BookLoanModel _bookLoan,
  ) {
    final textTheme = Theme.of(context).textTheme;
    if (_bookLoan.status == BookLoanStatus.requested) {
      return [
        Text("Você pediu este livro emprestado. Aguardando resposta..."),
      ];
    }
    if (_bookLoan.status == BookLoanStatus.lend) {
      return [
        RichText(
          text: TextSpan(
            text: "Você pegou emprestado até ",
            style: textTheme.bodyText1,
            children: [
              TextSpan(
                text: _bookLoan.expireDate,
                children: [
                  TextSpan(
                    text: ".",
                    style: textTheme.bodyText1,
                  ),
                ],
                style: TextStyle(
                  color: kSuccessColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ];
    }
    if (_bookLoan.status == BookLoanStatus.toDelivery) {
      return [
        Text("Ele(a) aceitou te emprestar o livro!"),
        Button(
          outlined: true,
          label: "Já estou com o livro",
          fullWidth: true,
          onPressed: () {
            Modal.confirm(
              message: "Você realmente confirma que o livro já está com você?",
              onConfirm: () async {
                this._enableIsWaiting();
                await _bookLoanStore.readerAnticipatedLend(_bookLoan);
                this._disableIsWaiting();
              },
            );
          },
        ),
      ];
    }
    if (_bookLoan.toReturnReaderAnswer) {
      return [
        Text(
          "Você informou que já devolveu o livro. Aguardando o proprietário confirmar pra finalizar o empréstimo.",
        ),
      ];
    }
    return [
      Text(
        "Você pegou este livro emprestado.",
      ),
      Button(
        outlined: true,
        fullWidth: true,
        label: "Já devolvi ele",
        isLoading: _isWaiting,
        isDisabled: _isWaiting,
        onPressed: () {
          Modal.confirm(
            message:
                "Você realmente confirma que entregou o livro para o proprietário dele?",
            onConfirm: () async {
              this._enableIsWaiting();
              await _bookLoanStore.readerSaidHeAlreadyReturned(_bookLoan);
              this._disableIsWaiting();
            },
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScaffold(
      title: "Detalhes do livro",
      onBackPressed: _isWaiting ? null : _bookStore.unselectBook,
      shouldPop: false,
      trailing: Observer(
        builder: (_) {
          if (_bookStore.selectedBook == null ||
              !_bookStore.currentUserIsOwnerOfSelectedBook) {
            return SizedBox();
          }
          return IconButton(
            icon: Icon(
              EditIcon,
              size: 14,
            ),
            color: kSuccessColor,
            onPressed: _bookStore.didWantToEditBook,
          );
        },
      ),
      child: Observer(
        builder: (_) {
          if (_bookStore.selectedBook == null) {
            return LoadingView();
          }
          final book = _bookStore.selectedBook;
          final isOwnerOfTheBook = _bookStore.currentUserIsOwnerOfSelectedBook;
          final borrowedBookLoan =
              _bookLoanStore.getBorrowedBookLoanOfBookIfExists(book.id);
          final borrowedThisBook = borrowedBookLoan != null;
          final loanedBookLoan =
              _bookLoanStore.getLoanedBookLoanOfBookIfExists(book.id);
          final loanedThisBook = loanedBookLoan != null;

          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (loanedThisBook)
                        ...this.renderLoanedBookWidgets(loanedBookLoan),
                      if (borrowedThisBook)
                        ...this.renderBorrowedBookWidgets(borrowedBookLoan),
                      if (loanedThisBook || borrowedThisBook)
                        Divider(height: 46),
                      BookItemWidget(
                        book,
                        hideButton: true,
                        hideUser: isOwnerOfTheBook,
                        hideActionButtons: isOwnerOfTheBook || borrowedThisBook,
                        displayAllImages: book.imagesList
                            .where((image) => image.hasUrl)
                            .isNotEmpty,
                        customStatus: borrowedThisBook
                            ? borrowedBookLoan.status.labelTo
                            : null,
                      ),
                      ...this._renderDescription(book.description),
                      Divider(height: 46),
                      SectionTitle("O que falam sobre o livro"),
                      SizedBox(height: 12),
                      for (var review in _bookStore.selectedBookReviews)
                        BookReviewWidget(review),
                      Observer(
                        builder: (_) {
                          final didRead =
                              Modular.get<AuthStore>().currentUserDidReadBook(
                            isbn: book.isbn,
                          );
                          if (didRead) return SizedBox();

                          return Button(
                            label:
                                "Já leu esse livro?\nDê sua opinião sobre ele!",
                            fullWidth: true,
                            small: true,
                            flat: true,
                            onPressed: () => BookCollectRatingModal.open(book),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (!isOwnerOfTheBook && !borrowedThisBook)
                SafeArea(
                  child: SubmitButton(
                    label: "QUERO ESSE LIVRO",
                    onPressed: () {
                      _bookStore.setSelectedBookForLoanId(book.id);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
