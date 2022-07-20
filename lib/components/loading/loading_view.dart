import 'package:flutter/material.dart';
import 'package:sabia_app/components/animation/lottie_animation.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: LottieAnimation.typing(
          width: 180,
          repeat: true,
        ),
      ),
    );
  }
}
