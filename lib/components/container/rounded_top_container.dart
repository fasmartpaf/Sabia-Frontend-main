import 'package:flutter/material.dart';

class RoundedTopContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color cardColor;
  const RoundedTopContainer({
    this.child,
    this.backgroundColor,
    this.cardColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Card(
        color: cardColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        child: child,
      ),
    );
  }
}
