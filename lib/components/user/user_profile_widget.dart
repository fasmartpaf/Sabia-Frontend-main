import "package:build_context/build_context.dart";
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../container/rounded_bottom_container.dart';
import '../../model/user_model.dart';

import 'profile_image.dart';

class UserProfileWidget extends StatelessWidget {
  final UserModel user;
  final Color backgroundColor;
  final List<Widget> beforeWidgets;
  final List<Widget> afterWidgets;
  final bool isFetchingProfileImage;
  final bool hideInformation;
  final Function onTapProfileImage;

  const UserProfileWidget(
    this.user, {
    this.backgroundColor,
    this.beforeWidgets,
    this.afterWidgets,
    this.isFetchingProfileImage = false,
    this.hideInformation = false,
    this.onTapProfileImage,
    Key key,
  }) : super(key: key);

  Widget _overlineText(
    String text,
    TextTheme textTheme,
  ) {
    if (text == null || text.isEmpty) return SizedBox();
    return Text(
      text,
      style: textTheme.overline,
    );
  }

  Widget _separator() => SizedBox(height: 6);

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuerySize.width;
    final bool isSmallScreen = width < 360;

    final textTheme = context.textTheme;

    return RoundedBottomContainer(
      cardColor: this.backgroundColor ?? context.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 30,
            vertical: isSmallScreen ? 6 : 16,
          ),
          child: Column(
            children: <Widget>[
              if (beforeWidgets != null) ...beforeWidgets,
              if (beforeWidgets != null) SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: this.onTapProfileImage,
                    child: isFetchingProfileImage
                        ? SizedBox(
                            height: 80,
                            width: 80,
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Observer(
                            builder: (_) => ProfileImage(
                              name: this.user.name,
                              imageUrl: this.user.imageUrl,
                            ),
                          ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          this.user.name,
                          maxLines: 2,
                          style: textTheme.headline5.copyWith(fontSize: 16),
                        ),
                        if (!this.hideInformation) ...[
                          _separator(),
                          _overlineText(this.user.email, textTheme),
                          _separator(),
                          _overlineText(this.user.displayPhone, textTheme),
                          _separator(),
                          _overlineText(this.user.location, textTheme),
                        ],
                        if (afterWidgets != null) ...afterWidgets,
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
