import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:sabia_app/utils/phone_utils.dart';

import 'rating_model.dart';
import 'image_model.dart';

part 'user_model.g.dart';

class UserModel = _UserModelBase with _$UserModel;

abstract class _UserModelBase with Store {
  String id;
  String name;
  String email;
  String phone;
  String location;
  bool isPublicProfile;
  RatingModel rating;
  @observable
  ObservableList<String> didRead = ObservableList<String>();
  @observable
  ObservableList<String> readLater = ObservableList<String>();
  @observable
  ImageModel image;

  _UserModelBase({
    this.id,
    this.name = "",
    this.rating,
    this.phone,
    this.email = "",
    this.location = "",
    this.isPublicProfile = true,
    this.didRead,
    this.readLater,
    this.image,
  });

  String get displayPhone {
    return displayPhoneFromString(this.phone);
  }

  List<String> get didReadBooksIsbn => this.didRead ?? [];
  List<String> get readLaterBooksIsbn => this.readLater ?? [];

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'isPublicProfile': isPublicProfile,
      'rating': rating?.toMap(),
      'didRead': didRead.toList(),
      'readLater': readLater.toList(),
      "image": image != null ? image.toMap() : null,
    };
  }

  Map<String, dynamic> toMapBasic() {
    return {
      'id': id,
      'name': name,
      'isPublicProfile': isPublicProfile,
    };
  }

  _UserModelBase.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    this.id = map['id'];
    this.name = map['name'] ?? "";
    this.email = map['email'] ?? "";
    this.phone = map['phone'];
    this.location = map['location'] ?? "";
    this.isPublicProfile = map['isPublicProfile'] ?? true;
    this.rating =
        map['rating'] != null ? RatingModel.fromMap(map['rating']) : null;
    if (map['didRead'] != null) {
      this.setDidRead(List<String>.from(map['didRead']));
    }
    if (map['readLater'] != null) {
      this.setReadLater(List<String>.from(map['readLater']));
    }
    this.image = map['image'] != null ? ImageModel.fromMap(map['image']) : null;
  }

  String toJson() => json.encode(toMap());

  @action
  setImage(ImageModel newValue) => this.image = newValue;
  @action
  setDidRead(List<String> newList) => this.didRead = newList.asObservable();
  @action
  setReadLater(List<String> newList) => this.readLater = newList.asObservable();

  @computed
  String get imageUrl {
    return this.image?.url;
  }
}
