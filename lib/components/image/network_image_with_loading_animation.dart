import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWithLoadingAnimation extends StatelessWidget {
  final String imageUrl;
  final Widget onErrorWidget;
  final double height;
  final double width;
  final Function(String) onErrorUrl;

  const NetworkImageWithLoadingAnimation(
    this.imageUrl, {
    this.height = 120,
    this.width = double.maxFinite,
    this.onErrorWidget,
    this.onErrorUrl,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: this.height,
      width: this.width,
      fit: BoxFit.cover,
      imageUrl: this.imageUrl,
      placeholder: (_, __) => Center(child: CircularProgressIndicator()),
      errorWidget: (_, url, ___) {
        if (this.onErrorUrl != null) {
          this.onErrorUrl(url);
        }
        return this.onErrorWidget;
      },
    );
  }
}
