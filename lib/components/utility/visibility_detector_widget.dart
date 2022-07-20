import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VisibilityDetectorWidget extends StatelessWidget {
  final Key key;
  final Widget child;
  final Function(bool) onChanged;
  const VisibilityDetectorWidget({
    @required this.key,
    @required this.child,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: this.key,
      child: this.child,
      onVisibilityChanged: (VisibilityInfo info) {
        final visiblePercentage = info.visibleFraction * 100;
        this.onChanged(visiblePercentage > 80);
      },
    );
  }
}
