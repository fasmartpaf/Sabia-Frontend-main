// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ImageModel on _ImageModelBase, Store {
  Computed<bool> _$hasUrlComputed;

  @override
  bool get hasUrl => (_$hasUrlComputed ??=
          Computed<bool>(() => super.hasUrl, name: '_ImageModelBase.hasUrl'))
      .value;
  Computed<bool> _$hasNoUrlComputed;

  @override
  bool get hasNoUrl =>
      (_$hasNoUrlComputed ??= Computed<bool>(() => super.hasNoUrl,
              name: '_ImageModelBase.hasNoUrl'))
          .value;

  final _$urlAtom = Atom(name: '_ImageModelBase.url');

  @override
  String get url {
    _$urlAtom.reportRead();
    return super.url;
  }

  @override
  set url(String value) {
    _$urlAtom.reportWrite(value, super.url, () {
      super.url = value;
    });
  }

  final _$_ImageModelBaseActionController =
      ActionController(name: '_ImageModelBase');

  @override
  dynamic setUrl(String newValue) {
    final _$actionInfo = _$_ImageModelBaseActionController.startAction(
        name: '_ImageModelBase.setUrl');
    try {
      return super.setUrl(newValue);
    } finally {
      _$_ImageModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
url: ${url},
hasUrl: ${hasUrl},
hasNoUrl: ${hasNoUrl}
    ''';
  }
}
