import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'model_utils.dart';

class AuthorModel {
  String id;
  String name;
  AuthorModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static AuthorModel fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return AuthorModel(
      id: map['id'],
      name: map['name'],
    );
  }

  static AuthorModel fromSnapshot(DataSnapshot snapshot) {
    if (snapshot == null) return null;
    return AuthorModel.fromMap(mapFromSnapshot(snapshot));
  }

  String toJson() => json.encode(toMap());

  static AuthorModel fromJson(String source) => fromMap(json.decode(source));
}
