import "package:build_context/build_context.dart";
import 'package:flutter/material.dart';

class ListTileText extends StatelessWidget {
  final String text;
  final Widget trailing;
  final String subtitle;
  final Widget leading;
  const ListTileText(
    this.text, {
    Key key,
    this.leading,
    this.trailing,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: this.trailing,
      leading: this.leading,
      title: Text(
        text,
        style: context.textTheme.bodyText1,
      ),
      subtitle: this.subtitle != null
          ? Text(
              subtitle,
              style: context.textTheme.bodyText1,
            )
          : null,
    );
  }
}
