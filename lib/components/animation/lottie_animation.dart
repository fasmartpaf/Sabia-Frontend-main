import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum AnimationType {
  typing,
}

extension AnimationTypeExtension on AnimationType {
  String get value => this.toString().split(".").last;
}

class LottieAnimation extends StatelessWidget {
  final AnimationType type;
  final double width;
  final bool repeat;

  const LottieAnimation(
    this.type, {
    Key key,
    this.width,
    this.repeat = false,
  }) : super(key: key);

  const LottieAnimation.typing({
    this.type = AnimationType.typing,
    Key key,
    this.width,
    this.repeat = false,
  });

  String _getAssetPathForType(AnimationType type) {
    return "assets/lottie/${type.value}.json";
  }

  @override
  Widget build(BuildContext context) {
    final path = _getAssetPathForType(this.type);
    if (path == null) return SizedBox();

    return Lottie.asset(
      path,
      width: this.width,
      repeat: this.repeat,
    );
  }
}
