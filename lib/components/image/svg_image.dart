import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGImage extends StatelessWidget {
  final String imageName;
  final String alt;
  final Color color;
  const SVGImage(this.imageName, {Key key, this.color, this.alt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/svg/$imageName.svg",
      color: color,
      semanticsLabel: this.alt,
    );
  }
}
