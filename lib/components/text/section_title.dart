import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final TextAlign textAlign;

  const SectionTitle(
    this.title, {
    Key key,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      textAlign: this.textAlign,
      maxLines: 2,
      style: theme.textTheme.headline5.copyWith(fontSize: 16),
    );
  }
}
