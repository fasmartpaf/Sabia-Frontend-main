import 'package:flutter/material.dart';
import 'package:sabia_app/utils/styles.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget titleWidget;
  final Widget child;
  final Widget leading;
  final Widget trailing;
  final Widget floatingActionButton;
  const AppScaffold({
    @required this.child,
    Key key,
    this.leading,
    this.trailing,
    this.floatingActionButton,
    this.title,
    this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: kGrayBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: this.titleWidget != null
            ? this.titleWidget
            : this.title == null
                ? SizedBox()
                : Text(
                    this.title,
                    maxLines: 2,
                    style: theme.textTheme.headline6.copyWith(
                      fontSize: 22,
                    ),
                  ),
        automaticallyImplyLeading: false,
        leading: this.leading,
        actions: [
          if (this.trailing != null) this.trailing,
        ],
      ),
      floatingActionButton: this.floatingActionButton,
      body: child,
    );
  }
}
