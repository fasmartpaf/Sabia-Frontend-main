import 'package:flutter/material.dart';

class RoundedBottomContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color cardColor;
  const RoundedBottomContainer({
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
            bottomLeft: Radius.circular(26),
            bottomRight: Radius.circular(26),
          ),
        ),
        child: child,
      ),
    );
  }
}
