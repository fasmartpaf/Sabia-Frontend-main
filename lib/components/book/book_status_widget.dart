import 'package:flutter/material.dart';
import 'package:sabia_app/model/book/book_model.dart';
import 'package:sabia_app/utils/styles.dart';

class BookStatusWidget extends StatelessWidget {
  final BookStatus status;
  final String customStatus;
  const BookStatusWidget(
    this.status, {
    this.customStatus,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var label = "Empréstimo";
    var color = kYellowBackgroundColor;

    if (this.customStatus != null) {
      label = this.customStatus;
      color = kGrayInactiveColor;
    } else if (status == BookStatus.lend) {
      label = "Emprestado";
      color = Colors.grey[200];
    } else if (status == BookStatus.library) {
      label = "Biblioteca";
      color = Colors.blue[100];
    } else if (status == BookStatus.donation) {
      label = "Doação";
      color = Colors.green[100];
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(26),
        ),
        color: color,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Text(
        label,
        // textAlign: TextAlign.center,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 12,
        ),
      ),
    );
  }
}
