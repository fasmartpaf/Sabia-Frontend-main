// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BookModel on _BookModelBase, Store {
  Computed<bool> _$hasCoverComputed;

  @override
  bool get hasCover => (_$hasCoverComputed ??=
          Computed<bool>(() => super.hasCover, name: '_BookModelBase.hasCover'))
      .value;
  Computed<String> _$coverUrlComputed;

  @override
  String get coverUrl =>
      (_$coverUrlComputed ??= Computed<String>(() => super.coverUrl,
              name: '_BookModelBase.coverUrl'))
          .value;
  Computed<bool> _$hasDetailsComputed;

  @override
  bool get hasDetails =>
      (_$hasDetailsComputed ??= Computed<bool>(() => super.hasDetails,
              name: '_BookModelBase.hasDetails'))
          .value;
  Computed<String> _$descriptionComputed;

  @override
  String get description =>
      (_$descriptionComputed ??= Computed<String>(() => super.description,
              name: '_BookModelBase.description'))
          .value;

  final _$coverAtom = Atom(name: '_BookModelBase.cover');

  @override
  ImageModel get cover {
    _$coverAtom.reportRead();
    return super.cover;
  }

  @override
  set cover(ImageModel value) {
    _$coverAtom.reportWrite(value, super.cover, () {
      super.cover = value;
    });
  }

  final _$imagesListAtom = Atom(name: '_BookModelBase.imagesList');

  @override
  List<ImageModel> get imagesList {
    _$imagesListAtom.reportRead();
    return super.imagesList;
  }

  @override
  set imagesList(List<ImageModel> value) {
    _$imagesListAtom.reportWrite(value, super.imagesList, () {
      super.imagesList = value;
    });
  }

  final _$detailsAtom = Atom(name: '_BookModelBase.details');

  @override
  BookDetailsModel get details {
    _$detailsAtom.reportRead();
    return super.details;
  }

  @override
  set details(BookDetailsModel value) {
    _$detailsAtom.reportWrite(value, super.details, () {
      super.details = value;
    });
  }

  final _$_BookModelBaseActionController =
      ActionController(name: '_BookModelBase');

  @override
  dynamic setCover(ImageModel newValue) {
    final _$actionInfo = _$_BookModelBaseActionController.startAction(
        name: '_BookModelBase.setCover');
    try {
      return super.setCover(newValue);
    } finally {
      _$_BookModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setImage(ImageModel newValue, int index) {
    final _$actionInfo = _$_BookModelBaseActionController.startAction(
        name: '_BookModelBase.setImage');
    try {
      return super.setImage(newValue, index);
    } finally {
      _$_BookModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDetails(BookDetailsModel newValue) {
    final _$actionInfo = _$_BookModelBaseActionController.startAction(
        name: '_BookModelBase.setDetails');
    try {
      return super.setDetails(newValue);
    } finally {
      _$_BookModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cover: ${cover},
imagesList: ${imagesList},
details: ${details},
hasCover: ${hasCover},
coverUrl: ${coverUrl},
hasDetails: ${hasDetails},
description: ${description}
    ''';
  }
}
