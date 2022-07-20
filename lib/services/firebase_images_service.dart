import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pedantic/pedantic.dart';

import '../interfaces/images_service_interface.dart';
import '../model/user_model.dart';
import '../model/book/book_model.dart';
import '../model/file_upload_model.dart';
import '../model/image_model.dart';
import '../services/firebase_service.dart';
import '../utils/utils.dart';

const SAVED_IMAGES_FILENAME = "savedImages";

class FirebaseImagesService implements ImagesServiceInterface {
  final FirebaseService _firebaseService;

  Map<String, ImageModel> imagesCache = {};
  Map<String, FileUploadModel> imagesUploadHandler = {};

  FirebaseImagesService(this._firebaseService);

  void _saveOnCache(String id, ImageModel image) {
    if (this.imagesCache.containsKey(id)) {
      return;
    }
    this.imagesCache[id] = image;
  }

  ImageModel _getFromCache(String id) {
    return this.imagesCache.containsKey(id) ? this.imagesCache[id] : null;
  }

  Future<String> _getImageDownloadUrl(String imagePath) async {
    try {
      final imageUrl = await this
          ._firebaseService
          .storage
          .ref()
          .child(imagePath)
          .getDownloadURL();

      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String> _getUserImageDownloadUrl(String userId, String imageId) async {
    final downloadUrl = await this
        ._getImageDownloadUrl("/users/${userId}/${imageId}_200x200.jpg");

    if (downloadUrl != null) {
      unawaited(this
          ._firebaseService
          .usersRef
          .child("$userId/image/url")
          .set(downloadUrl));
    }

    return downloadUrl;
  }

  Future<String> _getBookImageDownloadUrl(String bookId, String imageId) async {
    final downloadUrl = await this
        ._getImageDownloadUrl("/books/$bookId/${imageId}_900x1200.jpg");

    if (downloadUrl != null) {
      final index = imageId.substring(imageId.length - 1);
      final dbImageName = index == "0" ? "cover" : "image$index";
      unawaited(this
          ._firebaseService
          .booksRef
          .child("$bookId/$dbImageName/url")
          .set(downloadUrl));
    }

    return downloadUrl;
  }

  @override
  Future<void> getBookImage(BookModel book, int imageIndex) async {
    final isCover = imageIndex == 0;
    final imageName = isCover ? "cover" : "image$imageIndex";
    final cacheKey = "${book.id}_$imageName";

    ImageModel bookImage =
        isCover ? book.cover : book.getImageAtIndex(imageIndex);
    //* If null try to get from cache
    if (bookImage == null) {
      bookImage = this._getFromCache(cacheKey);
    }

    //* If still null try to get from database
    if (bookImage == null) {
      final snapshot = await this
          ._firebaseService
          .booksRef
          .child(book.id)
          .child(imageName)
          .once();
      if (snapshot.value != null) {
        bookImage = ImageModel.fromMap(snapshot.value);
      }
    }
    if (bookImage?.id == null) {
      return null;
    }

    if (bookImage.hasNoUrl) {
      final imageUrl = await this._getBookImageDownloadUrl(
        book.id,
        bookImage.id,
      );

      if (imageUrl != null) {
        bookImage.setUrl(imageUrl);
      }
    }

    this._saveOnCache(cacheKey, bookImage);
    if (isCover) {
      book.setCover(bookImage);
    } else {
      book.setImage(bookImage, imageIndex);
    }
  }

  @override
  Future<void> getBookCover(BookModel book) => this.getBookImage(book, 0);

  @override
  Future<void> getUserImage(UserModel user) async {
    final cacheKey = "${user.id}_image";
    ImageModel userImage = user.image ?? this._getFromCache(cacheKey);
    if (userImage == null) {
      final snapshot = await this
          ._firebaseService
          .usersRef
          .child(user.id)
          .child("image")
          .once();
      if (snapshot.value != null) {
        userImage = ImageModel.fromMap(snapshot.value);
      }
    }

    if (userImage?.id == null) {
      return null;
    }

    if (userImage.hasNoUrl) {
      final imageUrl = await this._getUserImageDownloadUrl(
        user.id,
        userImage?.id ?? "image",
      );

      if (imageUrl != null) {
        userImage.setUrl(imageUrl);
      }
    }

    this._saveOnCache(cacheKey, userImage);
    user.setImage(userImage);
  }

  @override
  Future<void> uploadBookImages(
    List<File> images, {
    @required BookModel book,
  }) async {
    int index = 0;
    for (final image in images) {
      final imageId = "${uuid()}_$index";
      final databaseRef = this
          ._firebaseService
          .booksRef
          .child(book.id)
          .child(index == 0 ? "cover" : "image$index");
      await this._firebaseService.uploadToStorage(
          fullPath: "/books/${book.id}/$imageId.jpg",
          file: image,
          listenerCallback: (
            StorageUploadTask uploadTask,
            StorageTaskEvent event,
            StorageReference fileRef,
          ) {
            if (!imagesUploadHandler.containsKey(imageId)) {
              imagesUploadHandler[imageId] =
                  FileUploadModel(databaseRef, imageId: imageId);
            }
            final uploadModel = imagesUploadHandler[imageId];

            final StorageTaskSnapshot snapshot = event.snapshot;
            if (event.type == StorageTaskEventType.progress) {
              uploadModel.setStatus(FILE_UPLOAD_STATUS.UPLOADING);
              uploadModel.setProgress(
                snapshot.bytesTransferred / snapshot.totalByteCount,
              );
            } else {
              uploadModel.setProgress(0);

              if (event.type == StorageTaskEventType.success) {
                uploadModel.setStatus(FILE_UPLOAD_STATUS.SUCCESS);
              } else if (event.type == StorageTaskEventType.failure) {
                uploadModel.setStatus(FILE_UPLOAD_STATUS.ERROR);
                debugPrint("ChatStore upload error: ${snapshot.error}");
              }
            }
          });

      index++;
    }

    this._scheduleClear();
  }

  _scheduleClear() => unawaited(Future.delayed(
        Duration(minutes: 1),
        this._clearFinished,
      ));

  _clearFinished() {
    try {
      for (final key in this.imagesUploadHandler.keys) {
        final uploadModel = this.imagesUploadHandler[key];
        if (uploadModel.isFinished) {
          this.imagesUploadHandler.remove(key);
        }
      }
    } catch (e) {
      //
    }
  }

  @override
  Future<void> uploadUserProfileImage(
    File image, {
    UserModel user,
  }) async {
    final imageId = uuid();
    final databaseRef =
        this._firebaseService.usersRef.child(user.id).child("image");
    await this._firebaseService.uploadToStorage(
        fullPath: "/users/${user.id}/$imageId.jpg",
        file: image,
        listenerCallback: (
          StorageUploadTask uploadTask,
          StorageTaskEvent event,
          StorageReference fileRef,
        ) {
          if (!imagesUploadHandler.containsKey(imageId)) {
            imagesUploadHandler[imageId] =
                FileUploadModel(databaseRef, imageId: imageId);
          }
          final uploadModel = imagesUploadHandler[imageId];

          final StorageTaskSnapshot snapshot = event.snapshot;
          if (event.type == StorageTaskEventType.progress) {
            uploadModel.setStatus(FILE_UPLOAD_STATUS.UPLOADING);
            uploadModel.setProgress(
              snapshot.bytesTransferred / snapshot.totalByteCount,
            );
          } else {
            uploadModel.setProgress(0);

            if (event.type == StorageTaskEventType.success) {
              uploadModel.setStatus(FILE_UPLOAD_STATUS.SUCCESS);
            } else if (event.type == StorageTaskEventType.failure) {
              uploadModel.setStatus(FILE_UPLOAD_STATUS.ERROR);
              debugPrint("ChatStore upload error: ${snapshot.error}");
            }
          }
        });
  }

  @override
  Future<void> deleteImage(String path) {
    return this._firebaseService.deleteFileFromStorage(path);
  }
}
