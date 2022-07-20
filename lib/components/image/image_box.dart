import 'dart:io';

import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  final String imageUrl;
  final File imageFile;

  const ImageBox({Key key, this.imageFile, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.imageFile != null) return Image.file(this.imageFile);

    if (this.imageUrl != null) return Image.network(this.imageUrl);

    return Container();
  }
}
