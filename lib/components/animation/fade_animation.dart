import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final Duration duration;
  final Widget child;
  FadeAnimation({
    Key key,
    this.duration,
    this.child,
  }) : super(key: key);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> {
  double _opacity = 0;

  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.mounted) {
        setState(() => this._opacity = 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: this._opacity,
      duration: this.widget.duration ?? Duration(milliseconds: 600),
      child: this.widget.child,
    );
  }
}
