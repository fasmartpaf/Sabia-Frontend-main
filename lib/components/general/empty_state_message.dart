import 'package:flutter/material.dart';
import 'package:sabia_app/utils/styles.dart';

class EmptyStateMessage extends StatelessWidget {
  const EmptyStateMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Você já viu tudo :)",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: kGrayActiveColor,
            fontSize: 12,
          ),
    );
  }
}
