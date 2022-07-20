import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/stores/routing_store.dart';

import '../../../components/loading/loading_view.dart';
import '../../../components/modal/modal.dart';
import '../../../components/button/submit_button.dart';
import '../../../components/scaffold/no_pop_scaffold.dart';
import '../../../components/text/section_title.dart';
import '../../../stores/book_store.dart';
import '../../../utils/styles.dart';
import '../../../model/book/book_model.dart';

class BookReviewPage extends StatefulWidget {
  final BookModel book;
  final double rating;
  BookReviewPage(this.book, {@required this.rating, Key key}) : super(key: key);

  @override
  _BookReviewPageState createState() => _BookReviewPageState();
}

class _BookReviewPageState extends State<BookReviewPage> {
  final _bookStore = Modular.get<BookStore>();
  String _description = "";
  bool _isWaiting = false;

  void setIsWaiting(bool newValue) => setState(() => _isWaiting = newValue);

  void _tryToSubmit() {
    if (this._description.isEmpty) {
      Modal.confirm(
        title: "Enviar em branco?",
        message:
            "Suas percepções sobre o livro podem ser muito úteis para outros possíveis leitores!",
        onConfirm: this._submit,
        cancelLabel: "Voltar",
        confirmLabel: "Avaliar assim mesmo",
      );
    } else {
      this._submit();
    }
  }

  void _submit() async {
    setIsWaiting(true);
    await _bookStore.saveNewBookReview(
      this.widget.book,
      rating: this.widget.rating,
      description: _description,
    );

    Modular.get<RoutingStore>().backRoute();
  }

  @override
  Widget build(BuildContext context) {
    return NoPopScaffold(
      title: "Avalie o livro",
      trailing: FlatButton(
        child: Text(
          "Pular",
          style: TextStyle(
            color: kSuccessColor,
          ),
        ),
        onPressed: this._submit,
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20,
            ),
            child: SectionTitle("Divide aqui com a gente as suas percepções"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                maxLines: double.maxFinite.floor(),
                keyboardType: TextInputType.multiline,
                readOnly: _isWaiting,
                decoration: InputDecoration(
                  hintText: "Escreva aqui...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => setState(() => _description = value),
              ),
            ),
          ),
          SizedBox(height: 30),
          SafeArea(
            child: _isWaiting
                ? LoadingView()
                : SubmitButton(
                    label: "ENVIAR AVALIAÇÃO",
                    onPressed: this._tryToSubmit,
                  ),
          ),
        ],
      ),
    );
  }
}
