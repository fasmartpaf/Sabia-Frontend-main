// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_loan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BookLoanStore on _BookLoanStoreBase, Store {
  Computed<bool> _$didSucceededRequestingLoanComputed;

  @override
  bool get didSucceededRequestingLoan =>
      (_$didSucceededRequestingLoanComputed ??= Computed<bool>(
              () => super.didSucceededRequestingLoan,
              name: '_BookLoanStoreBase.didSucceededRequestingLoan'))
          .value;
  Computed<bool> _$isRequestingLoanComputed;

  @override
  bool get isRequestingLoan => (_$isRequestingLoanComputed ??= Computed<bool>(
          () => super.isRequestingLoan,
          name: '_BookLoanStoreBase.isRequestingLoan'))
      .value;
  Computed<String> _$selectedLoanIdComputed;

  @override
  String get selectedLoanId =>
      (_$selectedLoanIdComputed ??= Computed<String>(() => super.selectedLoanId,
              name: '_BookLoanStoreBase.selectedLoanId'))
          .value;
  Computed<DatabaseReference> _$selectedLoanRefComputed;

  @override
  DatabaseReference get selectedLoanRef => (_$selectedLoanRefComputed ??=
          Computed<DatabaseReference>(() => super.selectedLoanRef,
              name: '_BookLoanStoreBase.selectedLoanRef'))
      .value;
  Computed<List<BookModel>> _$currentUserBorrowedLoanedBooksListComputed;

  @override
  List<BookModel> get currentUserBorrowedLoanedBooksList =>
      (_$currentUserBorrowedLoanedBooksListComputed ??=
              Computed<List<BookModel>>(
                  () => super.currentUserBorrowedLoanedBooksList,
                  name:
                      '_BookLoanStoreBase.currentUserBorrowedLoanedBooksList'))
          .value;
  Computed<List<BookModel>> _$currentUserLoanedLoanedBooksListComputed;

  @override
  List<BookModel> get currentUserLoanedLoanedBooksList =>
      (_$currentUserLoanedLoanedBooksListComputed ??= Computed<List<BookModel>>(
              () => super.currentUserLoanedLoanedBooksList,
              name: '_BookLoanStoreBase.currentUserLoanedLoanedBooksList'))
          .value;

  final _$selectedBookLoanAtom =
      Atom(name: '_BookLoanStoreBase.selectedBookLoan');

  @override
  BookLoanModel get selectedBookLoan {
    _$selectedBookLoanAtom.reportRead();
    return super.selectedBookLoan;
  }

  @override
  set selectedBookLoan(BookLoanModel value) {
    _$selectedBookLoanAtom.reportWrite(value, super.selectedBookLoan, () {
      super.selectedBookLoan = value;
    });
  }

  final _$relatedBookLoanRecordsAtom =
      Atom(name: '_BookLoanStoreBase.relatedBookLoanRecords');

  @override
  ObservableList<BookLoanModel> get relatedBookLoanRecords {
    _$relatedBookLoanRecordsAtom.reportRead();
    return super.relatedBookLoanRecords;
  }

  @override
  set relatedBookLoanRecords(ObservableList<BookLoanModel> value) {
    _$relatedBookLoanRecordsAtom
        .reportWrite(value, super.relatedBookLoanRecords, () {
      super.relatedBookLoanRecords = value;
    });
  }

  final _$isFetchingRelatedRecordsAtom =
      Atom(name: '_BookLoanStoreBase.isFetchingRelatedRecords');

  @override
  bool get isFetchingRelatedRecords {
    _$isFetchingRelatedRecordsAtom.reportRead();
    return super.isFetchingRelatedRecords;
  }

  @override
  set isFetchingRelatedRecords(bool value) {
    _$isFetchingRelatedRecordsAtom
        .reportWrite(value, super.isFetchingRelatedRecords, () {
      super.isFetchingRelatedRecords = value;
    });
  }

  final _$requestLoanStatusAtom =
      Atom(name: '_BookLoanStoreBase.requestLoanStatus');

  @override
  RequestLoanStatus get requestLoanStatus {
    _$requestLoanStatusAtom.reportRead();
    return super.requestLoanStatus;
  }

  @override
  set requestLoanStatus(RequestLoanStatus value) {
    _$requestLoanStatusAtom.reportWrite(value, super.requestLoanStatus, () {
      super.requestLoanStatus = value;
    });
  }

  final _$currentUserBorrowedBookLoansAtom =
      Atom(name: '_BookLoanStoreBase.currentUserBorrowedBookLoans');

  @override
  ObservableList<BookLoanModel> get currentUserBorrowedBookLoans {
    _$currentUserBorrowedBookLoansAtom.reportRead();
    return super.currentUserBorrowedBookLoans;
  }

  @override
  set currentUserBorrowedBookLoans(ObservableList<BookLoanModel> value) {
    _$currentUserBorrowedBookLoansAtom
        .reportWrite(value, super.currentUserBorrowedBookLoans, () {
      super.currentUserBorrowedBookLoans = value;
    });
  }

  final _$currentUserLoanedBookLoansAtom =
      Atom(name: '_BookLoanStoreBase.currentUserLoanedBookLoans');

  @override
  ObservableList<BookLoanModel> get currentUserLoanedBookLoans {
    _$currentUserLoanedBookLoansAtom.reportRead();
    return super.currentUserLoanedBookLoans;
  }

  @override
  set currentUserLoanedBookLoans(ObservableList<BookLoanModel> value) {
    _$currentUserLoanedBookLoansAtom
        .reportWrite(value, super.currentUserLoanedBookLoans, () {
      super.currentUserLoanedBookLoans = value;
    });
  }

  final _$daysToLoanAtom = Atom(name: '_BookLoanStoreBase.daysToLoan');

  @override
  double get daysToLoan {
    _$daysToLoanAtom.reportRead();
    return super.daysToLoan;
  }

  @override
  set daysToLoan(double value) {
    _$daysToLoanAtom.reportWrite(value, super.daysToLoan, () {
      super.daysToLoan = value;
    });
  }

  final _$_BookLoanStoreBaseActionController =
      ActionController(name: '_BookLoanStoreBase');

  @override
  dynamic setSelectedBookLoan(BookLoanModel bookLoan) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase.setSelectedBookLoan');
    try {
      return super.setSelectedBookLoan(bookLoan);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setRelatedBookLoanRecords(List<BookLoanModel> newList) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase.setRelatedBookLoanRecords');
    try {
      return super.setRelatedBookLoanRecords(newList);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsFetchingRelatedRecords(bool newValue) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase.setIsFetchingRelatedRecords');
    try {
      return super.setIsFetchingRelatedRecords(newValue);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _setRequestLoanStatus(RequestLoanStatus newValue) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase._setRequestLoanStatus');
    try {
      return super._setRequestLoanStatus(newValue);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentUserBorrowedBookLoans(List<BookLoanModel> newList) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase.setCurrentUserBorrowedBookLoans');
    try {
      return super.setCurrentUserBorrowedBookLoans(newList);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentUserLoanedBookLoans(List<BookLoanModel> newList) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase.setCurrentUserLoanedBookLoans');
    try {
      return super.setCurrentUserLoanedBookLoans(newList);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDaysToLoan(double newValue) {
    final _$actionInfo = _$_BookLoanStoreBaseActionController.startAction(
        name: '_BookLoanStoreBase.setDaysToLoan');
    try {
      return super.setDaysToLoan(newValue);
    } finally {
      _$_BookLoanStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedBookLoan: ${selectedBookLoan},
relatedBookLoanRecords: ${relatedBookLoanRecords},
isFetchingRelatedRecords: ${isFetchingRelatedRecords},
requestLoanStatus: ${requestLoanStatus},
currentUserBorrowedBookLoans: ${currentUserBorrowedBookLoans},
currentUserLoanedBookLoans: ${currentUserLoanedBookLoans},
daysToLoan: ${daysToLoan},
didSucceededRequestingLoan: ${didSucceededRequestingLoan},
isRequestingLoan: ${isRequestingLoan},
selectedLoanId: ${selectedLoanId},
selectedLoanRef: ${selectedLoanRef},
currentUserBorrowedLoanedBooksList: ${currentUserBorrowedLoanedBooksList},
currentUserLoanedLoanedBooksList: ${currentUserLoanedLoanedBooksList}
    ''';
  }
}
