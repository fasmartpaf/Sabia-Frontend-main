import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/components/image/network_image_with_loading_animation.dart';
import 'package:sabia_app/utils/styles.dart';

class ProfileImage extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double height;
  const ProfileImage({
    Key key,
    this.name,
    this.imageUrl,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String nameInitials = this.name == null
        ? ""
        : this
            .name
            .trim()
            .split(RegExp('\\s+'))
            .map((e) => e.substring(0, 1))
            .toList()
            .join();
    Widget placeholder = Container(
      width: this.height,
      height: this.height,
      padding: EdgeInsets.all(4),
      child: Center(
        child: AutoSizeText(
          nameInitials,
          maxLines: 1,
          minFontSize: 6,
          maxFontSize: 22,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

    return CircleAvatar(
      backgroundColor: kOrangeColor,
      radius: 40,
      child: ClipOval(
        child: imageUrl != null
            ? NetworkImageWithLoadingAnimation(
                this.imageUrl,
                height: this.height,
                onErrorWidget: placeholder,
              )
            : placeholder,
      ),
    );
  }
}
