import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:build_context/build_context.dart";
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/stores/auth_store.dart';

import '../../model/user_model.dart';
import '../../routes/app_routes.dart';
import '../../stores/routing_store.dart';

import 'profile_image.dart';

class UserFeedWidget extends StatelessWidget {
  final UserModel user;
  final bool alignCenter;
  const UserFeedWidget(
    this.user, {
    this.alignCenter = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final child = Row(
      mainAxisAlignment:
          alignCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 22,
          height: 22,
          child: Observer(
            builder: (_) => ProfileImage(
              name: this.user.name,
              imageUrl: this.user.imageUrl,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          this.user.name,
          style: textTheme.headline5.copyWith(
            fontSize: 14,
          ),
        ),
      ],
    );

    if (this.user.id != null &&
        this.user.id.isNotEmpty &&
        this.user.id != Modular.get<AuthStore>().uid) {
      return InkWell(
        onTap: () {
          Modular.get<RoutingStore>()
              .replaceToRoute(APP_ROUTE.USER_PROFILE.pathWithId(
            this.user.id,
          ));
        },
        child: child,
      );
    }

    return child;
  }
}
