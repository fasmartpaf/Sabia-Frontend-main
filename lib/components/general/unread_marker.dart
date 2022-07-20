import 'package:flutter/material.dart';
import 'package:sabia_app/components/animation/blinking_animation.dart';
import 'package:sabia_app/utils/styles.dart';

class UnreadMarker extends StatelessWidget {
  const UnreadMarker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlinkingAnimation(
      child: ClipOval(
        child: Container(
          width: 8,
          height: 8,
          color: kOrangeColor,
        ),
      ),
    );
  }
}
