import 'package:flutter/material.dart';

class CloseKeyboardGestureDetector extends StatelessWidget {
  final Widget child;
  const CloseKeyboardGestureDetector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: this.child,
    );
  }
}
