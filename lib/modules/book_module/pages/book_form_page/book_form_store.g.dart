// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BookFormStore on BookFormStoreBase, Store {
  Computed<bool> _$isValidImagesComputed;

  @override
  bool get isValidImages =>
      (_$isValidImagesComputed ??= Computed<bool>(() => super.isValidImages,
              name: 'BookFormStoreBase.isValidImages'))
          .value;
  Computed<bool> _$isValidAuthorsComputed;

  @override
  bool get isValidAuthors =>
      (_$isValidAuthorsComputed ??= Computed<bool>(() => super.isValidAuthors,
              name: 'BookFormStoreBase.isValidAuthors'))
          .value;
  Computed<bool> _$isValidIsbnComputed;

  @override
  bool get isValidIsbn =>
      (_$isValidIsbnComputed ??= Computed<bool>(() => super.isValidIsbn,
              name: 'BookFormStoreBase.isValidIsbn'))
          .value;
  Computed<bool> _$isValidTitleComputed;

  @override
  bool get isValidTitle =>
      (_$isValidTitleComputed ??= Computed<bool>(() => super.isValidTitle,
              name: 'BookFormStoreBase.isValidTitle'))
          .value;
  Computed<bool> _$isIsbnViewComputed;

  @override
  bool get isIsbnView =>
      (_$isIsbnViewComputed ??= Computed<bool>(() => super.isIsbnView,
              name: 'BookFormStoreBase.isIsbnView'))
          .value;
  Computed<bool> _$isConfirmMetadataViewComputed;

  @override
  bool get isConfirmMetadataView => (_$isConfirmMetadataViewComputed ??=
          Computed<bool>(() => super.isConfirmMetadataView,
              name: 'BookFormStoreBase.isConfirmMetadataView'))
      .value;
  Computed<bool> _$isNotFoundByIsbnViewComputed;

  @override
  bool get isNotFoundByIsbnView => (_$isNotFoundByIsbnViewComputed ??=
          Computed<bool>(() => super.isNotFoundByIsbnView,
              name: 'BookFormStoreBase.isNotFoundByIsbnView'))
      .value;
  Computed<bool> _$isMetadataViewComputed;

  @override
  bool get isMetadataView =>
      (_$isMetadataViewComputed ??= Computed<bool>(() => super.isMetadataView,
              name: 'BookFormStoreBase.isMetadataView'))
          .value;
  Computed<bool> _$isImagesViewComputed;

  @override
  bool get isImagesView =>
      (_$isImagesViewComputed ??= Computed<bool>(() => super.isImagesView,
              name: 'BookFormStoreBase.isImagesView'))
          .value;
  Computed<String> _$validateImagesMessageComputed;

  @override
  String get validateImagesMessage => (_$validateImagesMessageComputed ??=
          Computed<String>(() => super.validateImagesMessage,
              name: 'BookFormStoreBase.validateImagesMessage'))
      .value;
  Computed<String> _$validateIsbnMessageComputed;

  @override
  String get validateIsbnMessage => (_$validateIsbnMessageComputed ??=
          Computed<String>(() => super.validateIsbnMessage,
              name: 'BookFormStoreBase.validateIsbnMessage'))
      .value;
  Computed<String> _$validateTitleMessageComputed;

  @override
  String get validateTitleMessage => (_$validateTitleMessageComputed ??=
          Computed<String>(() => super.validateTitleMessage,
              name: 'BookFormStoreBase.validateTitleMessage'))
      .value;
  Computed<String> _$validateAuthorsMessageComputed;

  @override
  String get validateAuthorsMessage => (_$validateAuthorsMessageComputed ??=
          Computed<String>(() => super.validateAuthorsMessage,
              name: 'BookFormStoreBase.validateAuthorsMessage'))
      .value;
  Computed<bool> _$shouldDisplaySubmitButtonComputed;

  @override
  bool get shouldDisplaySubmitButton => (_$shouldDisplaySubmitButtonComputed ??=
          Computed<bool>(() => super.shouldDisplaySubmitButton,
              name: 'BookFormStoreBase.shouldDisplaySubmitButton'))
      .value;
  Computed<String> _$submitButtonLabelComputed;

  @override
  String get submitButtonLabel => (_$submitButtonLabelComputed ??=
          Computed<String>(() => super.submitButtonLabel,
              name: 'BookFormStoreBase.submitButtonLabel'))
      .value;
  Computed<IconData> _$submitButtonIconComputed;

  @override
  IconData get submitButtonIcon => (_$submitButtonIconComputed ??=
          Computed<IconData>(() => super.submitButtonIcon,
              name: 'BookFormStoreBase.submitButtonIcon'))
      .value;

  final _$isbnAtom = Atom(name: 'BookFormStoreBase.isbn');

  @override
  String get isbn {
    _$isbnAtom.reportRead();
    return super.isbn;
  }

  @override
  set isbn(String value) {
    _$isbnAtom.reportWrite(value, super.isbn, () {
      super.isbn = value;
    });
  }

  final _$titleAtom = Atom(name: 'BookFormStoreBase.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$authorsAtom = Atom(name: 'BookFormStoreBase.authors');

  @override
  String get authors {
    _$authorsAtom.reportRead();
    return super.authors;
  }

  @override
  set authors(String value) {
    _$authorsAtom.reportWrite(value, super.authors, () {
      super.authors = value;
    });
  }

  final _$coverUrlAtom = Atom(name: 'BookFormStoreBase.coverUrl');

  @override
  String get coverUrl {
    _$coverUrlAtom.reportRead();
    return super.coverUrl;
  }

  @override
  set coverUrl(String value) {
    _$coverUrlAtom.reportWrite(value, super.coverUrl, () {
      super.coverUrl = value;
    });
  }

  final _$statusAtom = Atom(name: 'BookFormStoreBase.status');

  @override
  BookStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(BookStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$isManualIsbnAtom = Atom(name: 'BookFormStoreBase.isManualIsbn');

  @override
  bool get isManualIsbn {
    _$isManualIsbnAtom.reportRead();
    return super.isManualIsbn;
  }

  @override
  set isManualIsbn(bool value) {
    _$isManualIsbnAtom.reportWrite(value, super.isManualIsbn, () {
      super.isManualIsbn = value;
    });
  }

  final _$isSearchingBookAtom = Atom(name: 'BookFormStoreBase.isSearchingBook');

  @override
  bool get isSearchingBook {
    _$isSearchingBookAtom.reportRead();
    return super.isSearchingBook;
  }

  @override
  set isSearchingBook(bool value) {
    _$isSearchingBookAtom.reportWrite(value, super.isSearchingBook, () {
      super.isSearchingBook = value;
    });
  }

  final _$imagesAtom = Atom(name: 'BookFormStoreBase.images');

  @override
  ObservableList<dynamic> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableList<dynamic> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  final _$viewAtom = Atom(name: 'BookFormStoreBase.view');

  @override
  BookFormStoreView get view {
    _$viewAtom.reportRead();
    return super.view;
  }

  @override
  set view(BookFormStoreView value) {
    _$viewAtom.reportWrite(value, super.view, () {
      super.view = value;
    });
  }

  final _$isWaitingFormAtom = Atom(name: 'BookFormStoreBase.isWaitingForm');

  @override
  bool get isWaitingForm {
    _$isWaitingFormAtom.reportRead();
    return super.isWaitingForm;
  }

  @override
  set isWaitingForm(bool value) {
    _$isWaitingFormAtom.reportWrite(value, super.isWaitingForm, () {
      super.isWaitingForm = value;
    });
  }

  final _$formWasSubmitAtom = Atom(name: 'BookFormStoreBase.formWasSubmit');

  @override
  bool get formWasSubmit {
    _$formWasSubmitAtom.reportRead();
    return super.formWasSubmit;
  }

  @override
  set formWasSubmit(bool value) {
    _$formWasSubmitAtom.reportWrite(value, super.formWasSubmit, () {
      super.formWasSubmit = value;
    });
  }

  final _$BookFormStoreBaseActionController =
      ActionController(name: 'BookFormStoreBase');

  @override
  dynamic setIsbn(String newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setIsbn');
    try {
      return super.setIsbn(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTitle(String newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setTitle');
    try {
      return super.setTitle(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAuthors(String newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setAuthors');
    try {
      return super.setAuthors(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCoverUrl(String newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setCoverUrl');
    try {
      return super.setCoverUrl(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setStatus(BookStatus newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setStatus');
    try {
      return super.setStatus(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsManualIsbn(bool newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setIsManualIsbn');
    try {
      return super.setIsManualIsbn(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsSearchingBook(bool newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setIsSearchingBook');
    try {
      return super.setIsSearchingBook(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setImages(List<dynamic> newList) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setImages');
    try {
      return super.setImages(newList);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addImage(dynamic newFile) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.addImage');
    try {
      return super.addImage(newFile);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeImage(int indexToRemove) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.removeImage');
    try {
      return super.removeImage(indexToRemove);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsWaitingForm(bool newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setIsWaitingForm');
    try {
      return super.setIsWaitingForm(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFormWasSubmit(bool newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase.setFormWasSubmit');
    try {
      return super.setFormWasSubmit(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setView(BookFormStoreView newValue) {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase._setView');
    try {
      return super._setView(newValue);
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _resetMetadata() {
    final _$actionInfo = _$BookFormStoreBaseActionController.startAction(
        name: 'BookFormStoreBase._resetMetadata');
    try {
      return super._resetMetadata();
    } finally {
      _$BookFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isbn: ${isbn},
title: ${title},
authors: ${authors},
coverUrl: ${coverUrl},
status: ${status},
isManualIsbn: ${isManualIsbn},
isSearchingBook: ${isSearchingBook},
images: ${images},
view: ${view},
isWaitingForm: ${isWaitingForm},
formWasSubmit: ${formWasSubmit},
isValidImages: ${isValidImages},
isValidAuthors: ${isValidAuthors},
isValidIsbn: ${isValidIsbn},
isValidTitle: ${isValidTitle},
isIsbnView: ${isIsbnView},
isConfirmMetadataView: ${isConfirmMetadataView},
isNotFoundByIsbnView: ${isNotFoundByIsbnView},
isMetadataView: ${isMetadataView},
isImagesView: ${isImagesView},
validateImagesMessage: ${validateImagesMessage},
validateIsbnMessage: ${validateIsbnMessage},
validateTitleMessage: ${validateTitleMessage},
validateAuthorsMessage: ${validateAuthorsMessage},
shouldDisplaySubmitButton: ${shouldDisplaySubmitButton},
submitButtonLabel: ${submitButtonLabel},
submitButtonIcon: ${submitButtonIcon}
    ''';
  }
}
