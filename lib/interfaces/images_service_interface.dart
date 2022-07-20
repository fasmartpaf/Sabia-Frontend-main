import 'dart:io';
import 'package:flutter/foundation.dart';

import '../model/user_model.dart';
import '../model/book/book_model.dart';

abstract class ImagesServiceInterface {
  Future<void> getBookImage(BookModel book, int imageIndex);
  Future<void> getBookCover(BookModel book);

  Future<void> getUserImage(UserModel user);

  Future<void> uploadBookImages(
    List<File> images, {
    @required BookModel book,
  });

  Future<void> uploadUserProfileImage(
    File image, {
    @required UserModel user,
  });

  Future<void> deleteImage(String path);
}
