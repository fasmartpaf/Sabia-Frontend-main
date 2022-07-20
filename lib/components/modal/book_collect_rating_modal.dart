import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import "package:build_context/build_context.dart";

import '../../model/book/book_model.dart';
import '../../routes/app_routes.dart';
import '../../services/notifications_service.dart';
import '../../stores/routing_store.dart';

import '../rating/rating_widget.dart';
import '../text/section_title.dart';
import '../button/button.dart';
import 'modal.dart';

class BookCollectRatingModalWidget extends StatefulWidget {
  final BookModel book;
  BookCollectRatingModalWidget(this.book, {Key key}) : super(key: key);

  @override
  _BookCollectRatingModalState createState() => _BookCollectRatingModalState();
}

class _BookCollectRatingModalState extends State<BookCollectRatingModalWidget> {
  double _rating = 0;

  void _setRating(double newValue) => setState(() => _rating = newValue);

  void _submit() {
    if (_rating == 0) {
      Modular.get<NotificationsService>()
          .notifyWarning("Toque nas estrelas para dar uma nota para o livro!");
    } else {
      Modular.to.pop();
      Modular.get<RoutingStore>().moveToRoute(
          APP_ROUTE.BOOK_REVIEW.pathWithId(this.widget.book.id),
          arguments: {
            "book": this.widget.book,
            "rating": this._rating,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuerySize.width;
    final bool isSmallScreen = width < 360;

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionTitle("Já leu esse livro? Me fala o que achou dele :)"),
          SizedBox(height: 32),
          RatingWidget(
            value: _rating,
            onChanged: _setRating,
            small: isSmallScreen,
          ),
          SizedBox(height: 12),
          SectionTitle(this.widget.book.title),
          SizedBox(height: 40),
          Button(
            label: "CONTINUAR",
            fullWidth: true,
            onPressed: this._submit,
            padding: EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }
}

class BookCollectRatingModal {
  static open(BookModel book) {
    Modal.custom(
      barrierDismissible: true,
      content: BookCollectRatingModalWidget(book),
    );
  }
}
