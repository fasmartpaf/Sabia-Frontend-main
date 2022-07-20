import 'dart:convert';

class RatingModel {
  int total;
  double rating;

  RatingModel({
    this.total = 0,
    this.rating = 0,
  });

  double get average => total > 0 && rating > 0 ? rating / total : 0;

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'rating': rating,
    };
  }

  static RatingModel fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return RatingModel(
      total: map['total'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  static RatingModel fromJson(String source) => fromMap(json.decode(source));
}
