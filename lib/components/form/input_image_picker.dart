import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sabia_app/components/book/book_image_widget.dart';
import '../container/dashed_border_container.dart';
import 'package:sabia_app/utils/styles.dart';

class InputImagePicker extends StatelessWidget {
  final List<dynamic> imagesList;
  final Function(int) onTap;
  const InputImagePicker({
    Key key,
    this.imagesList,
    this.onTap,
  }) : super(key: key);

  Widget _placeholderBox() {
    return DashedBorderContainer(
      borderColor: kOrangeColor,
      radius: 4,
      child: Container(
        height: 220,
        child: Center(
          child: Icon(
            Icons.camera_alt,
            size: 40,
            color: kOrangeColor,
          ),
        ),
      ),
    );
  }

  InkWell renderInkWell({
    Widget child,
    int index,
    String imageUrl,
  }) =>
      InkWell(
        onTap: () => this.onTap(index),
        child: BookImageWidget(
          imageUrl: imageUrl,
          imageWidget: child,
        ),
      );

  Widget _renderImage(
    dynamic image,
    int index,
  ) {
    if (image is File) {
      return renderInkWell(
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
        index: index,
      );
    }
    return renderInkWell(
      imageUrl: image,
      index: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return LimitedBox(
          maxHeight: 180,
          child: imagesList.isEmpty
              ? Center(
                  child: renderInkWell(child: _placeholderBox(), index: 0),
                )
              : ListView.separated(
                  separatorBuilder: (_, __) => SizedBox(width: 40),
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  itemCount: imagesList.length > 4 ? 5 : imagesList.length + 1,
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (index < imagesList.length) {
                      return _renderImage(imagesList[index], index);
                    } else {
                      return renderInkWell(
                          child: _placeholderBox(), index: index);
                    }
                  },
                ),
        );
      },
    );
  }
}
