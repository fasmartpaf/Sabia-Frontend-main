import 'package:flutter/material.dart';
import 'package:sabia_app/components/container/dashed_border_container.dart';
import 'package:sabia_app/components/image/network_image_with_loading_animation.dart';

class BookImageWidget extends StatelessWidget {
  final String imageUrl;
  final String alt;
  final double height;
  final Widget imageWidget;
  final Function onTap;
  final void Function(String) onErrorBookCoverUrl;
  const BookImageWidget({
    Key key,
    this.imageUrl,
    this.imageWidget,
    this.alt,
    this.height,
    this.onTap,
    this.onErrorBookCoverUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = DashedBorderContainer(
      child: this.alt != null
          ? Center(
              child: Text(
              this.alt,
              textAlign: TextAlign.center,
              maxLines: 3,
            ))
          : SizedBox(),
    );

    final imageBox = ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AspectRatio(
        aspectRatio: 1 / 1.6,
        child: this.imageWidget != null
            ? imageWidget
            : this.imageUrl != null && this.imageUrl.isNotEmpty
                ? NetworkImageWithLoadingAnimation(
                    this.imageUrl,
                    height: this.height,
                    onErrorWidget: placeholder,
                    onErrorUrl: this.onErrorBookCoverUrl,
                  )
                : placeholder,
      ),
    );

    if (this.onTap == null) {
      return imageBox;
    }

    return InkWell(
      onTap: onTap,
      child: imageBox,
    );
  }
}
