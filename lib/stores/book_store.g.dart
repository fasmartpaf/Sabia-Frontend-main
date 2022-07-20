// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BookStore on _BookStoreBase, Store {
  Computed<bool> _$currentUserIsOwnerOfSelectedBookComputed;

  @override
  bool get currentUserIsOwnerOfSelectedBook =>
      (_$currentUserIsOwnerOfSelectedBookComputed ??= Computed<bool>(
              () => super.currentUserIsOwnerOfSelectedBook,
              name: '_BookStoreBase.currentUserIsOwnerOfSelectedBook'))
          .value;
  Computed<bool> _$isDetailsViewComputed;

  @override
  bool get isDetailsView =>
      (_$isDetailsViewComputed ??= Computed<bool>(() => super.isDetailsView,
              name: '_BookStoreBase.isDetailsView'))
          .value;
  Computed<bool> _$isLoanViewComputed;

  @override
  bool get isLoanView =>
      (_$isLoanViewComputed ??= Computed<bool>(() => super.isLoanView,
              name: '_BookStoreBase.isLoanView'))
          .value;
  Computed<bool> _$isFormViewComputed;

  @override
  bool get isFormView =>
      (_$isFormViewComputed ??= Computed<bool>(() => super.isFormView,
              name: '_BookStoreBase.isFormView'))
          .value;
  Computed<bool> _$isAddingBookComputed;

  @override
  bool get isAddingBook =>
      (_$isAddingBookComputed ??= Computed<bool>(() => super.isAddingBook,
              name: '_BookStoreBase.isAddingBook'))
          .value;
  Computed<bool> _$isEditingBookComputed;

  @override
  bool get isEditingBook =>
      (_$isEditingBookComputed ??= Computed<bool>(() => super.isEditingBook,
              name: '_BookStoreBase.isEditingBook'))
          .value;

  final _$searchStringAtom = Atom(name: '_BookStoreBase.searchString');

  @override
  String get searchString {
    _$searchStringAtom.reportRead();
    return super.searchString;
  }

  @override
  set searchString(String value) {
    _$searchStringAtom.reportWrite(value, super.searchString, () {
      super.searchString = value;
    });
  }

  final _$booksListAtom = Atom(name: '_BookStoreBase.booksList');

  @override
  ObservableList<BookModel> get booksList {
    _$booksListAtom.reportRead();
    return super.booksList;
  }

  @override
  set booksList(ObservableList<BookModel> value) {
    _$booksListAtom.reportWrite(value, super.booksList, () {
      super.booksList = value;
    });
  }

  final _$selectedBookViewAtom = Atom(name: '_BookStoreBase.selectedBookView');

  @override
  SelectedBookView get selectedBookView {
    _$selectedBookViewAtom.reportRead();
    return super.selectedBookView;
  }

  @override
  set selectedBookView(SelectedBookView value) {
    _$selectedBookViewAtom.reportWrite(value, super.selectedBookView, () {
      super.selectedBookView = value;
    });
  }

  final _$selectedBookIdAtom = Atom(name: '_BookStoreBase.selectedBookId');

  @override
  String get selectedBookId {
    _$selectedBookIdAtom.reportRead();
    return super.selectedBookId;
  }

  @override
  set selectedBookId(String value) {
    _$selectedBookIdAtom.reportWrite(value, super.selectedBookId, () {
      super.selectedBookId = value;
    });
  }

  final _$selectedBookAtom = Atom(name: '_BookStoreBase.selectedBook');

  @override
  BookModel get selectedBook {
    _$selectedBookAtom.reportRead();
    return super.selectedBook;
  }

  @override
  set selectedBook(BookModel value) {
    _$selectedBookAtom.reportWrite(value, super.selectedBook, () {
      super.selectedBook = value;
    });
  }

  final _$selectedBookReviewsAtom =
      Atom(name: '_BookStoreBase.selectedBookReviews');

  @override
  ObservableList<BookReviewModel> get selectedBookReviews {
    _$selectedBookReviewsAtom.reportRead();
    return super.selectedBookReviews;
  }

  @override
  set selectedBookReviews(ObservableList<BookReviewModel> value) {
    _$selectedBookReviewsAtom.reportWrite(value, super.selectedBookReviews, () {
      super.selectedBookReviews = value;
    });
  }

  final _$currentUserBooksLibraryAtom =
      Atom(name: '_BookStoreBase.currentUserBooksLibrary');

  @override
  ObservableList<BookModel> get currentUserBooksLibrary {
    _$currentUserBooksLibraryAtom.reportRead();
    return super.currentUserBooksLibrary;
  }

  @override
  set currentUserBooksLibrary(ObservableList<BookModel> value) {
    _$currentUserBooksLibraryAtom
        .reportWrite(value, super.currentUserBooksLibrary, () {
      super.currentUserBooksLibrary = value;
    });
  }

  final _$_BookStoreBaseActionController =
      ActionController(name: '_BookStoreBase');

  @override
  void _setSelectedBookId(String newValue) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase._setSelectedBookId');
    try {
      return super._setSelectedBookId(newValue);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setSelectedBook(BookModel newValue) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase._setSelectedBook');
    try {
      return super._setSelectedBook(newValue);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setSelectedBookView(SelectedBookView newValue) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase._setSelectedBookView');
    try {
      return super._setSelectedBookView(newValue);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchString(String newValue) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase.setSearchString');
    try {
      return super.setSearchString(newValue);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBooksList(List<BookModel> newList) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase.setBooksList');
    try {
      return super.setBooksList(newList);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedBookReviews(List<BookReviewModel> newList) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase.setSelectedBookReviews');
    try {
      return super.setSelectedBookReviews(newList);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentUserBooksLibrary(List<BookModel> newList) {
    final _$actionInfo = _$_BookStoreBaseActionController.startAction(
        name: '_BookStoreBase.setCurrentUserBooksLibrary');
    try {
      return super.setCurrentUserBooksLibrary(newList);
    } finally {
      _$_BookStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchString: ${searchString},
booksList: ${booksList},
selectedBookView: ${selectedBookView},
selectedBookId: ${selectedBookId},
selectedBook: ${selectedBook},
selectedBookReviews: ${selectedBookReviews},
currentUserBooksLibrary: ${currentUserBooksLibrary},
currentUserIsOwnerOfSelectedBook: ${currentUserIsOwnerOfSelectedBook},
isDetailsView: ${isDetailsView},
isLoanView: ${isLoanView},
isFormView: ${isFormView},
isAddingBook: ${isAddingBook},
isEditingBook: ${isEditingBook}
    ''';
  }
}
