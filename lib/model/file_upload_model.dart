import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'package:mobx/mobx.dart';
part 'file_upload_model.g.dart';

enum FILE_UPLOAD_STATUS {
  UNDEFINED,
  UPLOADING,
  SUCCESS,
  ERROR,
  FINISHED,
}

class FileUploadModel = _FileUploadModelBase with _$FileUploadModel;

abstract class _FileUploadModelBase with Store {
  final DatabaseReference _ref;
  final String imageId;

  _FileUploadModelBase(
    this._ref, {
    @required this.imageId,
  }) {
    when((_) => this.isSuccessful, this.setData);
  }

  @observable
  FILE_UPLOAD_STATUS status;
  @observable
  double progress;

  @action
  setStatus(FILE_UPLOAD_STATUS newStatus) => this.status = newStatus;
  @action
  setProgress(double newValue) => this.progress = newValue;

  @computed
  String get displayProgress =>
      this.progress < 1 ? "0%" : (this.progress * 100).toStringAsFixed(0) + "%";

  @computed
  bool get isUploading => this.status == FILE_UPLOAD_STATUS.UPLOADING;
  @computed
  bool get isSuccessful => this.status == FILE_UPLOAD_STATUS.SUCCESS;
  @computed
  bool get isFailure => this.status == FILE_UPLOAD_STATUS.ERROR;
  @computed
  bool get isFinished => isSuccessful || isFailure;

  setData() async {
    try {
      if (this.isSuccessful) {
        await _ref.set({
          "id": this.imageId,
        });
      } else {
        await _ref.parent().child("imageError").child(this.imageId).set(true);
      }
    } catch (e) {
      print("error on setData of FileUploadModel: $e");
    }
  }
}
