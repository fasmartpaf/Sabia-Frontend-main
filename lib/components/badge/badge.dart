import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final int value;
  final String text;
  final double size;
  final Color color;
  const Badge({
    Key key,
    this.value,
    this.text,
    this.size = 30,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool moreThan99 = this.value != null && this.value > 99;
    return ClipOval(
      child: Container(
        color: this.color ?? Colors.green,
        height: this.size,
        width: this.size,
        padding: EdgeInsets.all(2),
        child: Center(
          child: AutoSizeText(
            this.text != null ? this.text : moreThan99 ? "99+" : "$value",
            minFontSize: 10,
            maxFontSize: 20,
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
