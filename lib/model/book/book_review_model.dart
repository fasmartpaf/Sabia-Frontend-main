import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../model_utils.dart';
import '../user_model.dart';

class BookReviewModel {
  UserModel user;
  String description;
  double rating;
  int createdDate;
  BookReviewModel({
    this.user,
    this.description,
    this.rating,
    this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'description': description,
      'rating': rating,
      'createdDate': createdDate,
    };
  }

  static BookReviewModel fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return BookReviewModel(
      user: UserModel.fromMap(map['user']),
      description: map['description'] ?? "",
      rating: map["rating"]?.toDouble() ?? 0,
      createdDate: map['createdDate'],
    );
  }

  static BookReviewModel fromSnapshot(DataSnapshot snapshot) {
    if (snapshot == null) return null;
    return BookReviewModel.fromMap(mapFromSnapshot(snapshot));
  }

  String toJson() => json.encode(toMap());

  static BookReviewModel fromJson(String source) =>
      fromMap(json.decode(source));
}
