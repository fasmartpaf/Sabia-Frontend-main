import 'dart:io';
import 'package:pedantic/pedantic.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../model/book/book_details_model.dart';
import '../model/user_model.dart';
import '../model/book/book_model.dart';
import '../model/book/book_review_model.dart';
import '../routes/app_routes.dart';
import '../interfaces/images_service_interface.dart';
import '../services/firebase_service.dart';
import '../services/notifications_service.dart';
import '../services/sabia_api_service.dart';
import '../utils/delayed.dart';

import 'auth_store.dart';
import 'analytics_store.dart';
import 'routing_store.dart';
part 'book_store.g.dart';

enum SelectedBookView {
  none,
  details,
  form,
  loan,
}

class BookStore = _BookStoreBase with _$BookStore;

abstract class _BookStoreBase extends Disposable with Store {
  List<ReactionDisposer> _disposersList;
  final AuthStore _authStore;
  final AnalyticsStore _analyticsStore;
  final RoutingStore _routingStore;
  final FirebaseService _firebaseService;
  final ImagesServiceInterface _imagesService;
  final NotificationsService _notificationsService;
  final SabiaApiService _sabiaApiService;

  _BookStoreBase(
    this._authStore,
    this._analyticsStore,
    this._routingStore,
    this._firebaseService,
    this._imagesService,
    this._notificationsService,
    this._sabiaApiService,
  ) {
    _disposersList ??= [
      reaction((_) => this._authStore.isAuthenticated, (bool isAuthenticated) {
        if (!isAuthenticated) {
          this.clearStore();
        }
      }),
      reaction(
          (_) => [
                this.selectedBookId,
                this.selectedBookView,
              ], (_) {
        if (this.selectedBookId != null &&
            this.selectedBookView != SelectedBookView.none) {
          APP_ROUTE route;
          if (this.isDetailsView) {
            route = APP_ROUTE.BOOK_DETAIL;
          }
          if (this.isLoanView) {
            route = APP_ROUTE.REQUEST_LOAN;
          } else if (this.isFormView) {
            route = APP_ROUTE.BOOK_FORM;
          }
          if (route != null) {
            _moveRouteWithId(route);
          }
        }
      }, delay: 200),
      reaction(
        (_) => this.selectedBookId,
        this.getSelectedBook,
      ),
      reaction(
        (_) => this.isDetailsView && this.selectedBook != null,
        (bool shouldRequestDetails) {
          if (shouldRequestDetails) {
            this.getBookDetails(this.selectedBook);
          }
        },
      ),
      reaction((_) => this.selectedBook != null && this.isDetailsView,
          (bool hasBook) {
        if (hasBook) {
          this._getSelectedBookReviews();
        } else {
          this.setSelectedBookReviews([]);
        }
      }),
    ];
  }

  @override
  void dispose() => _disposersList?.forEach((d) => d());

  clearStore() {
    this.setBooksList([]);
  }

  @observable
  String searchString = "";

  @observable
  ObservableList<BookModel> booksList = ObservableList<BookModel>();

  @observable
  SelectedBookView selectedBookView = SelectedBookView.none;

  @observable
  String selectedBookId;

  @observable
  BookModel selectedBook;

  @observable
  ObservableList<BookReviewModel> selectedBookReviews =
      ObservableList<BookReviewModel>();

  @observable
  ObservableList<BookModel> currentUserBooksLibrary =
      ObservableList<BookModel>();

  @computed
  bool get currentUserIsOwnerOfSelectedBook {
    if (this.selectedBookId == null || this.currentUserBooksLibrary.isEmpty) {
      return false;
    }
    return this
        .currentUserBooksLibrary
        .map((book) => book.id)
        .toList()
        .contains(this.selectedBookId);
  }

  @computed
  bool get isDetailsView => this.selectedBookView == SelectedBookView.details;
  @computed
  bool get isLoanView => this.selectedBookView == SelectedBookView.loan;
  @computed
  bool get isFormView => this.selectedBookView == SelectedBookView.form;
  @computed
  bool get isAddingBook => this.isFormView && this.selectedBookId == "new";
  @computed
  bool get isEditingBook =>
      this.isFormView && this.currentUserIsOwnerOfSelectedBook;

  @action
  void _setSelectedBookId(String newValue) => this.selectedBookId = newValue;
  @action
  void _setSelectedBook(BookModel newValue) => this.selectedBook = newValue;
  @action
  void _setSelectedBookView(SelectedBookView newValue) =>
      this.selectedBookView = newValue;

  @action
  void setSearchString(String newValue) => this.searchString = newValue;

  @action
  void setBooksList(List<BookModel> newList) =>
      this.booksList = newList.asObservable();
  @action
  void setSelectedBookReviews(List<BookReviewModel> newList) =>
      this.selectedBookReviews = newList.asObservable();
  @action
  void setCurrentUserBooksLibrary(List<BookModel> newList) =>
      this.currentUserBooksLibrary = newList.asObservable();

  List<BookModel> _booksListFromSnapshot(DataSnapshot snapshot) {
    List<BookModel> list = [];
    if (snapshot.value != null) {
      snapshot.value.forEach((key, value) {
        final book = BookModel.fromMap({...value, "id": key});

        if (!book.hasCover && book.cover != null) {
          unawaited(this.getBookCover(book));
        }
        unawaited(this._getUserImage(book.user));

        list.add(book);
      });
    }
    return list;
  }

  BookModel getBookByIdFromList(String id) {
    return this.booksList.firstWhere(
          (book) => book.id == this.selectedBookId,
          orElse: () => null,
        );
  }

  Future<List<BookModel>> fetchUserBooks(String userId) async {
    final snapshot = await this
        ._firebaseService
        .booksRef
        .orderByChild("user/id")
        .equalTo(userId)
        .once();

    return this._booksListFromSnapshot(snapshot);
  }

  Future<void> fetchCurrentUserBooks() async {
    List<BookModel> list = await this.fetchUserBooks(this._authStore.uid);
    this.setCurrentUserBooksLibrary(list);
  }

  Future<void> _getSelectedBookReviews() async {
    if (this.selectedBook.isbn.isEmpty) {
      return;
    }
    List<BookReviewModel> list = [];
    try {
      final snapshot = await this
          ._firebaseService
          .bookReviewsRef
          .child(this.selectedBook.isbn)
          .once();

      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          final bookReview = BookReviewModel.fromMap({...value, "id": key});
          if (bookReview != null) {
            unawaited(this._getUserImage(bookReview.user));
            list.add(bookReview);
          }
        });
      }
    } catch (e) {
      debugPrint("error in _getSelectedBookReviews $e");
    } finally {
      this.setSelectedBookReviews(list);
    }
  }

  Future<void> saveNewBookReview(
    BookModel book, {
    @required double rating,
    String description,
  }) async {
    try {
      final bookReviewPath = this
          ._firebaseService
          .bookReviewsRef
          .child(book.isbn)
          .child(this._authStore.uid)
          .path;

      final userReviewsOfBooksPath = await this
          ._firebaseService
          .userReviewsOfBooksRef
          .child(this._authStore.uid)
          .path;

      await this._firebaseService.applyRootRefUpdates({
        "$bookReviewPath/description": description,
        "$bookReviewPath/rating": rating,
        "$bookReviewPath/user": this._authStore.currentUser.toMapBasic(),
        "$userReviewsOfBooksPath/${book.isbn}": true,
      });
    } catch (e) {
      print("error in saveNewBookReview $e");
    }
  }

  setSelectedBookForDetailsId(String id) {
    this._analyticsStore.logSelectedContent(
          type: "book_detail",
          id: id,
        );
    this._setSelectedBookId(id);
    this._setSelectedBookView(SelectedBookView.details);
  }

  setSelectedBookForLoanId(String id) {
    this._analyticsStore.logSelectedContent(
          type: "book_loan",
          id: id,
        );
    this._setSelectedBookId(id);
    this._setSelectedBookView(SelectedBookView.loan);
  }

  setSelectedBookForFormId(String id) {
    this._setSelectedBookId(id);
    this._setSelectedBookView(SelectedBookView.form);
  }

  didWantToEditBook() {
    this._setSelectedBookView(SelectedBookView.form);
  }

  unselectBook() {
    this._setSelectedBookId(null);
    this._setSelectedBookView(SelectedBookView.none);

    this._routingStore.backRoute();
  }

  submitBook(
    BookModel book, {
    @required List<File> images,
  }) async {
    final minimumExecutionTime = DateTime.now().add(Duration(seconds: 3));

    final ref = this._firebaseService.booksRef.push();
    book.user = this._authStore.currentUser;
    book.id = ref.key;

    try {
      await ref.set({
        ...book.toMap(),
        "createdAt": this._firebaseService.serverTimestamp,
      });

      unawaited(
        this._imagesService.uploadBookImages(
              images,
              book: book,
            ),
      );
    } catch (e) {
      print("error on submitBook $e");
    }

    await delayUntil(minimumExecutionTime, this._backToHome);
  }

  updateBook({BookStatus updatedStatus}) async {
    if (updatedStatus != this.selectedBook.status) {
      try {
        final ref = this._firebaseService.booksRef.child(this.selectedBookId);
        await ref.update({
          "status": updatedStatus.value,
          "updatedAt": this._firebaseService.serverTimestamp,
        });
        this.selectedBook.status = updatedStatus;
      } catch (e) {
        print("error on updateBook $e");
      }
    }
    this._backToHome();
  }

  _backToHome() => this._routingStore.moveToMainRoute(APP_ROUTE.HOME.path);

  Future<void> _getUserImage(UserModel user) {
    return this._imagesService.getUserImage(user);
  }

  Future<void> getBookCover(BookModel book) =>
      this._imagesService.getBookCover(book);
  Future<void> getBookImage(BookModel book, int imageIndex) =>
      this._imagesService.getBookImage(book, imageIndex);

  Future<void> getSelectedBook(String bookId) async {
    BookModel book;
    if (bookId != null) {
      book = this.getBookByIdFromList(bookId);
      if (book == null && this.currentUserIsOwnerOfSelectedBook) {
        book = this.currentUserBooksLibrary.firstWhere(
              (book) => book.id == bookId,
              orElse: () => null,
            );
      }
      if (book == null) {
        try {
          final snapshot =
              await this._firebaseService.booksRef.child(bookId).once();
          book = BookModel.fromMap({...snapshot.value, "id": bookId});
        } catch (e) {
          print("error while getting book from id $e");
        }
      }
    }
    this._setSelectedBook(book);
  }

  Future<void> getBookDetails(BookModel book) async {
    final bookData = await this.getBookData(book.isbn);

    if (bookData != null) {
      final bookDetails = BookDetailsModel.fromMap(bookData);
      if (bookDetails != null) {
        book.setDetails(bookDetails);
      }
    }

    //* try to get book images
    if (book.imagesList.isNotEmpty) {
      for (var i = 1; i <= book.imagesList.length; i++) {
        unawaited(this.getBookImage(book, i));
      }
    }
  }

  Future<void> onErrorBookCoverUrl(BookModel book) async {
    await this._firebaseService.booksRef.child("${book.id}/coverUrl").remove();
    await this.getBookCover(book);
  }

  Future<Map<String, dynamic>> getBookData(String isbn) async {
    if (!this._authStore.isAuthenticated) return null;
    return await this._sabiaApiService.findBook(isbn);
  }

  setIsbnIsWrong(String isbn) {
    try {
      unawaited(this
          ._firebaseService
          .rootRef
          .child(
              "stats/isbnIsWrong/$isbn/${this._authStore.currentNotificationToken}")
          .set(true));
    } catch (e) {
      print("setIsbnIsWrong in setIsbnIsWrong $e");
    }
  }

  _moveRouteWithId(APP_ROUTE route) {
    this._routingStore.moveToRoute(
          route.pathWithId(this.selectedBookId),
        );
  }

  Future<void> deleteBook() async {
    if (!this.currentUserIsOwnerOfSelectedBook) {
      return;
    }

    try {
      await this._firebaseService.booksRef.child(this.selectedBookId).remove();
      this._notificationsService.notifySuccess(
            "Livro foi deletado com sucesso",
          );
      this._backToHome();
    } catch (e) {
      print("error in deleteBook $e");
    }
  }
}
