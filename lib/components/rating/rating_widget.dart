import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RatingWidget extends StatelessWidget {
  final double value;
  final bool small;
  final Function(double) onChanged;
  const RatingWidget({
    @required this.value,
    Key key,
    this.small = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: value,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemSize: small ? 30 : 40,
      itemCount: 5,
      unratedColor: Colors.grey[300],
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, index) {
        return Icon(
          FontAwesomeIcons.solidStar,
          color: Colors.amber,
        );
      },
      onRatingUpdate: onChanged,
    );
  }
}
