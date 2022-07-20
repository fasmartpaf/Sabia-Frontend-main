import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingAnimation extends StatefulWidget {
  final Widget child;
  BlinkingAnimation({Key key, this.child}) : super(key: key);

  @override
  _BlinkingAnimationState createState() => _BlinkingAnimationState();
}

class _BlinkingAnimationState extends State<BlinkingAnimation> {
  Timer _timer;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._loopAnimation();
      this._timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => this._loopAnimation(),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _toggleOpacity() {
    if (!this.mounted) {
      return;
    }
    setState(
      () => this._opacity = this._opacity == 1 ? 0 : 1,
    );
  }

  void _loopAnimation() {
    this._toggleOpacity();
    Future.delayed(
      Duration(milliseconds: 1000),
      this._toggleOpacity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: this._opacity,
      duration: Duration(milliseconds: 800),
      child: this.widget.child,
    );
  }
}
