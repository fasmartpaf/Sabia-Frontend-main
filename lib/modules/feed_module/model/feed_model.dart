import 'package:sabia_app/model/book/book_model.dart';
import 'package:sabia_app/model/user_model.dart';

enum FeedModelType {
  book,
  user,
}

class FeedModel {
  FeedModelType type;
  dynamic data;

  FeedModel(
    this.type,
    this.data,
  );

  static FeedModel fromMap(Map<dynamic, dynamic> map) {
    if (map["data"] == null) {
      return null;
    }
    if (map['type'] == "book") {
      final book = BookModel.fromMap(map["data"]);
      return FeedModel.book(data: book);
    }
    if (map['type'] == "user") {
      final user = UserModel.fromMap(map["data"]);
      return FeedModel.user(data: user);
    }

    return null;
  }

  static FeedModel book({
    dynamic data,
  }) {
    if (data != null && data is BookModel) {
      return FeedModel(FeedModelType.book, data);
    }
    return null;
  }

  static FeedModel user({
    dynamic data,
  }) {
    if (data != null && data is UserModel) {
      return FeedModel(FeedModelType.user, data);
    }
    return null;
  }

  bool get isBook => this.type == FeedModelType.book;
  bool get isUser => this.type == FeedModelType.user;

  BookModel get bookData {
    if (!this.isBook) return null;
    return data as BookModel;
  }

  UserModel get userData {
    if (!this.isUser) return null;
    return data as UserModel;
  }
}
