import 'package:flutter/material.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../container/app_card.dart';
import '../rating/rating_widget.dart';
import '../text/section_title.dart';
import '../user/profile_image.dart';
import '../../model/book/book_model.dart';
import '../../model/user_model.dart';

import './book_image_widget.dart';

const PAGE_VIEW_HORIZONTAL_PADDING = 4.0;

class BookActionDisplay extends StatelessWidget {
  final BookModel book;
  final String actionLabel;
  final List<UserModel> toUserList;

  const BookActionDisplay(
    this.book, {
    @required this.toUserList,
    this.actionLabel,
    Key key,
  }) : super(key: key);

  Widget _renderAppCard(
    BuildContext context,
    UserModel toUser,
  ) {
    final double profileSize = 60;

    final leftPadding =
        (context.mediaQuerySize.width - PAGE_VIEW_HORIZONTAL_PADDING * 2) / 2;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -46,
              left: leftPadding - profileSize,
              child: Row(
                children: <Widget>[
                  Container(
                    width: profileSize,
                    height: profileSize,
                    child: Observer(
                      builder: (_) => ProfileImage(
                        name: toUser.name,
                        imageUrl: toUser.imageUrl,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        toUser.name,
                        style: context.textTheme.headline5.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (toUser.rating != null)
                        RatingWidget(
                          value: toUser.rating.average,
                          small: true,
                        ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 140,
                        child: Observer(
                          builder: (_) => BookImageWidget(
                            alt: book.title,
                            imageUrl: book.coverUrl,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SectionTitle(book.title),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (this.actionLabel != null)
            SectionTitle(
              this.actionLabel,
            ),
          SizedBox(height: 10),
          Expanded(
            child: PageView(
              children: toUserList
                  .map((user) => Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 10,
                          left: PAGE_VIEW_HORIZONTAL_PADDING,
                          right: PAGE_VIEW_HORIZONTAL_PADDING,
                        ),
                        child: this._renderAppCard(context, user),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
