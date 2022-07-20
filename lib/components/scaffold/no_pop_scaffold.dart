import 'package:flutter/material.dart';

import 'app_scaffold.dart';

class NoPopScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget trailing;
  final Widget floatingActionButton;
  const NoPopScaffold({
    @required this.child,
    Key key,
    this.trailing,
    this.floatingActionButton,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: AppScaffold(
        title: this.title,
        floatingActionButton: this.floatingActionButton,
        child: this.child,
        trailing: this.trailing,
      ),
    );
  }
}
