import 'package:firebase_database/firebase_database.dart';

Map<String, dynamic> mapFromSnapshot(DataSnapshot snapshot) {
  if (snapshot == null) return {};

  try {
    var map = Map<String, dynamic>.from(snapshot.value);
    map["id"] = snapshot.key;

    return map;
  } catch (e) {
    return {};
  }
}
