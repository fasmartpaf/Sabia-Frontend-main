// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileUploadModel on _FileUploadModelBase, Store {
  Computed<String> _$displayProgressComputed;

  @override
  String get displayProgress => (_$displayProgressComputed ??= Computed<String>(
          () => super.displayProgress,
          name: '_FileUploadModelBase.displayProgress'))
      .value;
  Computed<bool> _$isUploadingComputed;

  @override
  bool get isUploading =>
      (_$isUploadingComputed ??= Computed<bool>(() => super.isUploading,
              name: '_FileUploadModelBase.isUploading'))
          .value;
  Computed<bool> _$isSuccessfulComputed;

  @override
  bool get isSuccessful =>
      (_$isSuccessfulComputed ??= Computed<bool>(() => super.isSuccessful,
              name: '_FileUploadModelBase.isSuccessful'))
          .value;
  Computed<bool> _$isFailureComputed;

  @override
  bool get isFailure =>
      (_$isFailureComputed ??= Computed<bool>(() => super.isFailure,
              name: '_FileUploadModelBase.isFailure'))
          .value;
  Computed<bool> _$isFinishedComputed;

  @override
  bool get isFinished =>
      (_$isFinishedComputed ??= Computed<bool>(() => super.isFinished,
              name: '_FileUploadModelBase.isFinished'))
          .value;

  final _$statusAtom = Atom(name: '_FileUploadModelBase.status');

  @override
  FILE_UPLOAD_STATUS get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(FILE_UPLOAD_STATUS value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$progressAtom = Atom(name: '_FileUploadModelBase.progress');

  @override
  double get progress {
    _$progressAtom.reportRead();
    return super.progress;
  }

  @override
  set progress(double value) {
    _$progressAtom.reportWrite(value, super.progress, () {
      super.progress = value;
    });
  }

  final _$_FileUploadModelBaseActionController =
      ActionController(name: '_FileUploadModelBase');

  @override
  dynamic setStatus(FILE_UPLOAD_STATUS newStatus) {
    final _$actionInfo = _$_FileUploadModelBaseActionController.startAction(
        name: '_FileUploadModelBase.setStatus');
    try {
      return super.setStatus(newStatus);
    } finally {
      _$_FileUploadModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setProgress(double newValue) {
    final _$actionInfo = _$_FileUploadModelBaseActionController.startAction(
        name: '_FileUploadModelBase.setProgress');
    try {
      return super.setProgress(newValue);
    } finally {
      _$_FileUploadModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
progress: ${progress},
displayProgress: ${displayProgress},
isUploading: ${isUploading},
isSuccessful: ${isSuccessful},
isFailure: ${isFailure},
isFinished: ${isFinished}
    ''';
  }
}
