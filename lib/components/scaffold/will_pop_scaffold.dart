import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/components/icon/app_icon.dart';
import 'package:sabia_app/utils/styles.dart';

import 'app_scaffold.dart';

class WillPopScaffold extends StatelessWidget {
  final String title;
  final Widget titleWidget;
  final Widget child;
  final Widget floatingActionButton;
  final Widget trailing;
  final bool shouldPop;
  final Function onBackPressed;
  const WillPopScaffold({
    @required this.child,
    Key key,
    this.floatingActionButton,
    this.shouldPop = true,
    this.title,
    this.titleWidget,
    this.trailing,
    this.onBackPressed,
  }) : super(key: key);

  void _back() {
    if (this.onBackPressed != null) this.onBackPressed();

    if (this.shouldPop) Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        this._back();
        return Future(() => false);
      },
      child: AppScaffold(
        title: this.title,
        titleWidget: this.titleWidget,
        floatingActionButton: this.floatingActionButton,
        leading: this.onBackPressed == null
            ? null
            : IconButton(
                icon: Icon(NavigationBackIcon),
                color: kSuccessColor,
                onPressed: _back,
              ),
        trailing: this.trailing,
        child: this.child,
      ),
    );
  }
}
