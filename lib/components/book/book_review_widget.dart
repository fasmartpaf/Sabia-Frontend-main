import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../rating/rating_widget.dart';
import '../user/profile_image.dart';
import '../../model/book/book_review_model.dart';

class BookReviewWidget extends StatelessWidget {
  final BookReviewModel review;
  const BookReviewWidget(
    this.review, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 22,
              height: 22,
              child: Observer(
                builder: (_) => ProfileImage(
                  name: review.user.name,
                  imageUrl: review.user.imageUrl,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                review.user.name,
                maxLines: 2,
                style: theme.textTheme.headline5.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
            RatingWidget(
              value: review.rating,
              small: true,
            ),
          ],
        ),
        SizedBox(height: 10),
        if (review.description.isNotEmpty)
          Text(
            review.description,
            maxLines: null,
          ),
        Divider(height: 26),
      ],
    );
  }
}
