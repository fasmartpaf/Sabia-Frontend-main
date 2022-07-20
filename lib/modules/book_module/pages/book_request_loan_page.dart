import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/components/book/book_action_display.dart';
import 'package:sabia_app/components/button/submit_button.dart';
import 'package:sabia_app/components/container/no_pop_container.dart';
import 'package:sabia_app/components/image/svg_image.dart';
import 'package:sabia_app/components/loading/loading_view.dart';
import 'package:sabia_app/components/scaffold/will_pop_scaffold.dart';
import 'package:sabia_app/components/text/card_message_text.dart';
import 'package:sabia_app/components/text/section_title.dart';
import 'package:sabia_app/stores/book_loan_store.dart';
import 'package:sabia_app/stores/book_store.dart';
import 'package:sabia_app/utils/styles.dart';

class BookRequestLoanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bookStore = Modular.get<BookStore>();
    final _bookLoanStore = Modular.get<BookLoanStore>();

    return Observer(
      builder: (_) {
        if (_bookLoanStore.didSucceededRequestingLoan) {
          return NoPopContainer(
            submitLabel: "CONTINUAR",
            onSubmit: _bookLoanStore.didExitRequestingBook,
            children: [
              SVGImage("checkmark", color: kSuccessColor),
              SizedBox(height: 40),
              SectionTitle("Já avisamos ao dono do livro"),
              SizedBox(height: 8),
              CardMessageText(
                "Agora é só esperar ele entrar em contato para marcarem o local de entrega.",
              ),
            ],
          );
        }

        return WillPopScaffold(
          title: "Quero esse livro",
          onBackPressed: _bookLoanStore.didExitRequestingBook,
          shouldPop: false,
          child: Observer(
            builder: (_) {
              if (_bookStore.selectedBook == null) {
                return LoadingView();
              }

              final book = _bookStore.selectedBook;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: BookActionDisplay(
                      book,
                      toUserList: [book.user],
                      actionLabel: "Enviar pedido de empréstimo para",
                    ),
                  ),
                  SafeArea(
                    child: _bookLoanStore.isRequestingLoan
                        ? LoadingView()
                        : SubmitButton(
                            label: "CONFIRMAR",
                            onPressed: _bookLoanStore.didRequestLoan,
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
