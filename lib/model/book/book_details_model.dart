import 'dart:convert';

class BookDetailsModel {
  String description;

  BookDetailsModel({
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }

  static BookDetailsModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BookDetailsModel(
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  static BookDetailsModel fromJson(String source) =>
      fromMap(json.decode(source));
}
