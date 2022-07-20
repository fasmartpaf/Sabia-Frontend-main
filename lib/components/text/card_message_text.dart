import 'package:flutter/material.dart';

class CardMessageText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const CardMessageText(
    this.text, {
    Key key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = this.style != null
        ? theme.textTheme.bodyText1.merge(this.style)
        : theme.textTheme.bodyText1;

    return Text(
      this.text,
      textAlign: TextAlign.center,
      maxLines: null,
      style: defaultStyle,
    );
  }
}
