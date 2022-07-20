import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double radius;
  const DashedBorderContainer(
      {this.child, this.radius, this.borderColor, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(this.radius ?? 12);
    return DottedBorder(
      color: this.borderColor ?? Colors.black,
      borderType: BorderType.RRect,
      strokeWidth: 2,
      dashPattern: [4, 4],
      radius: borderRadius,
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.all(borderRadius),
        child: child,
      ),
    );
  }
}
