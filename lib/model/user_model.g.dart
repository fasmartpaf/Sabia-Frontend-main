// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserModel on _UserModelBase, Store {
  Computed<String> _$imageUrlComputed;

  @override
  String get imageUrl =>
      (_$imageUrlComputed ??= Computed<String>(() => super.imageUrl,
              name: '_UserModelBase.imageUrl'))
          .value;

  final _$didReadAtom = Atom(name: '_UserModelBase.didRead');

  @override
  ObservableList<String> get didRead {
    _$didReadAtom.reportRead();
    return super.didRead;
  }

  @override
  set didRead(ObservableList<String> value) {
    _$didReadAtom.reportWrite(value, super.didRead, () {
      super.didRead = value;
    });
  }

  final _$readLaterAtom = Atom(name: '_UserModelBase.readLater');

  @override
  ObservableList<String> get readLater {
    _$readLaterAtom.reportRead();
    return super.readLater;
  }

  @override
  set readLater(ObservableList<String> value) {
    _$readLaterAtom.reportWrite(value, super.readLater, () {
      super.readLater = value;
    });
  }

  final _$imageAtom = Atom(name: '_UserModelBase.image');

  @override
  ImageModel get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(ImageModel value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  final _$_UserModelBaseActionController =
      ActionController(name: '_UserModelBase');

  @override
  dynamic setImage(ImageModel newValue) {
    final _$actionInfo = _$_UserModelBaseActionController.startAction(
        name: '_UserModelBase.setImage');
    try {
      return super.setImage(newValue);
    } finally {
      _$_UserModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDidRead(List<String> newList) {
    final _$actionInfo = _$_UserModelBaseActionController.startAction(
        name: '_UserModelBase.setDidRead');
    try {
      return super.setDidRead(newList);
    } finally {
      _$_UserModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReadLater(List<String> newList) {
    final _$actionInfo = _$_UserModelBaseActionController.startAction(
        name: '_UserModelBase.setReadLater');
    try {
      return super.setReadLater(newList);
    } finally {
      _$_UserModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
didRead: ${didRead},
readLater: ${readLater},
image: ${image},
imageUrl: ${imageUrl}
    ''';
  }
}
