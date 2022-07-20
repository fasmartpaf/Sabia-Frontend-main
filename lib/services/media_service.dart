import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LostMediaModel {
  File file;
  bool isImage;
  bool isVideo;
  LostMediaModel({
    this.file,
    this.isImage,
    this.isVideo,
  });
}

class MediaService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File> pickImage({
    bool fromGallery = false,
    bool preferSelfieCamera = false,
    int imageQuality = 60,
    double maxWidth = 3000,
  }) async {
    final PickedFile pickedFile = await _imagePicker.getImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: imageQuality ?? 60,
      maxWidth: maxWidth,
      preferredCameraDevice:
          preferSelfieCamera ? CameraDevice.front : CameraDevice.rear,
    );
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  Future<File> cropImage(
    File imageFile, {
    Color toolbarColor,
    Color toolbarWidgetColor,
    String title = "Ajuste a foto",
    String doneLabel = "Pronto",
    String cancelLabel = "Cancelar",
  }) async {
    return await ImageCropper.cropImage(
      maxHeight: 2400,
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 4),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: title,
        toolbarColor: toolbarColor,
        toolbarWidgetColor: toolbarWidgetColor,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        title: title,
        doneButtonTitle: doneLabel,
        cancelButtonTitle: cancelLabel,
      ),
    );
  }

  Future<LostMediaModel> retrieveLostMedia() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null || response.file == null) {
      return null;
    }

    return LostMediaModel(
      file: File(response.file.path),
      isImage: response.type == RetrieveType.image,
      isVideo: response.type == RetrieveType.video,
    );
  }
}
