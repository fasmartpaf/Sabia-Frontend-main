import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';
import 'package:pedantic/pedantic.dart';

import '../model/user_model.dart';
import '../model/book/book_loan_model.dart';
import '../model/book/book_model.dart';
import '../pages/display_message_page.dart';
import '../routes/app_routes.dart';
import '../services/sabia_api_service.dart';
import '../services/firebase_service.dart';
import '../services/notifications_service.dart';
import '../interfaces/images_service_interface.dart';
import '../stores/routing_store.dart';
import '../utils/utils.dart';
import '../utils/delayed.dart';

import 'auth_store.dart';
import 'book_store.dart';
part 'book_loan_store.g.dart';

class BookLoanStore = _BookLoanStoreBase with _$BookLoanStore;

enum RequestLoanStatus {
  initial,
  requesting,
  success,
  error,
}

abstract class _BookLoanStoreBase with Store {
  final AuthStore _authStore;
  final BookStore _bookStore;
  final RoutingStore _routingStore;
  final SabiaApiService _sabiaApiService;
  final FirebaseService _firebaseService;
  final ImagesServiceInterface _imagesService;
  final NotificationsService _notificationsService;

  dynamic _currentUserBorrowedBooksListener;
  dynamic _currentUserLoanedBooksListener;

  _BookLoanStoreBase(
    this._authStore,
    this._bookStore,
    this._routingStore,
    this._sabiaApiService,
    this._firebaseService,
    this._imagesService,
    this._notificationsService,
  ) {
    reaction((_) => this._authStore.isAuthenticated, (bool isAuthenticated) {
      if (isAuthenticated) {
        this.setCurrentUserBorrowedBooksListener();
        this.setCurrentUserLoanedBooksListener();
      } else {
        this.clearStore();
      }
    });
    reaction(
      (_) => this.selectedBookLoan,
      (BookLoanModel bookLoan) {
        if (bookLoan != null) {
          this.searchForRelatedBookLoanRecords(bookLoan);
        } else {
          this.setRelatedBookLoanRecords([]);
        }
      },
    );
  }

  clearStore() {
    this._currentUserBorrowedBooksListener?.cancel();
    this._currentUserLoanedBooksListener?.cancel();

    this.setDaysToLoan(30);
  }

  @observable
  BookLoanModel selectedBookLoan;

  @observable
  ObservableList<BookLoanModel> relatedBookLoanRecords =
      ObservableList<BookLoanModel>();

  @observable
  bool isFetchingRelatedRecords = false;

  @observable
  RequestLoanStatus requestLoanStatus = RequestLoanStatus.initial;

  @observable
  ObservableList<BookLoanModel> currentUserBorrowedBookLoans =
      ObservableList<BookLoanModel>();
  @observable
  ObservableList<BookLoanModel> currentUserLoanedBookLoans =
      ObservableList<BookLoanModel>();

  @observable
  double daysToLoan = 30;

  @action
  setSelectedBookLoan(BookLoanModel bookLoan) =>
      this.selectedBookLoan = bookLoan;

  @action
  setRelatedBookLoanRecords(List<BookLoanModel> newList) =>
      this.relatedBookLoanRecords = newList.asObservable();

  @action
  setIsFetchingRelatedRecords(bool newValue) =>
      this.isFetchingRelatedRecords = newValue;

  @action
  _setRequestLoanStatus(RequestLoanStatus newValue) =>
      this.requestLoanStatus = newValue;

  @action
  setCurrentUserBorrowedBookLoans(List<BookLoanModel> newList) =>
      this.currentUserBorrowedBookLoans = newList.asObservable();
  @action
  setCurrentUserLoanedBookLoans(List<BookLoanModel> newList) =>
      this.currentUserLoanedBookLoans = newList.asObservable();

  @action
  void setDaysToLoan(double newValue) => this.daysToLoan = newValue;

  @computed
  bool get didSucceededRequestingLoan =>
      this.requestLoanStatus == RequestLoanStatus.success;
  @computed
  bool get isRequestingLoan =>
      this.requestLoanStatus == RequestLoanStatus.requesting;

  @computed
  String get selectedLoanId => this.selectedBookLoan?.id;

  @computed
  DatabaseReference get selectedLoanRef => this.selectedLoanId == null
      ? null
      : this._firebaseService.bookLoansRef.child(this.selectedLoanId);

  @computed
  List<BookModel> get currentUserBorrowedLoanedBooksList {
    return this
        .currentUserBorrowedBookLoans
        .map((bookLoan) => bookLoan.book)
        .toList();
  }

  @computed
  List<BookModel> get currentUserLoanedLoanedBooksList {
    return this
        .currentUserLoanedBookLoans
        .map((bookLoan) => bookLoan.book)
        .toList();
  }

  BookLoanModel bookLoanFromSnapshot(Map<dynamic, dynamic> map) {
    final bookLoan = BookLoanModel.fromMap(map);
    unawaited(this.getBookCover(bookLoan.book));
    unawaited(this.getUserImage(bookLoan.toUser));
    unawaited(this.getUserImage(bookLoan.fromUser));

    return bookLoan;
  }

  Future<void> setCurrentUserBorrowedBooksListener() async {
    this._currentUserBorrowedBooksListener?.cancel();
    this._currentUserBorrowedBooksListener = this
        ._firebaseService
        .bookLoansRef
        .orderByChild("to/id")
        .equalTo(this._authStore.uid)
        .onValue
        .listen((Event event) {
      final snapshot = event.snapshot;
      List<BookLoanModel> list = [];
      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) async {
          final bookLoan = this.bookLoanFromSnapshot({...value, "id": key});
          if (bookLoan.status != BookLoanStatus.returned &&
              bookLoan.status != BookLoanStatus.canceled) {
            list.add(bookLoan);
          }
        });
      }

      this.setCurrentUserBorrowedBookLoans(list);
    });
  }

  Future<void> setCurrentUserLoanedBooksListener() async {
    this._currentUserLoanedBooksListener?.cancel();
    this._currentUserLoanedBooksListener = this
        ._firebaseService
        .bookLoansRef
        .orderByChild("from/id")
        .equalTo(this._authStore.uid)
        .onValue
        .listen((Event event) {
      final snapshot = event.snapshot;
      List<BookLoanModel> list = [];
      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) async {
          final bookLoan = this.bookLoanFromSnapshot({...value, "id": key});
          if (bookLoan.status != BookLoanStatus.returned &&
              bookLoan.status != BookLoanStatus.canceled) {
            list.add(bookLoan);
          }
        });
      }

      this.setCurrentUserLoanedBookLoans(list);
    });
  }

  Future<BookLoanModel> getBookLoan(String id) async {
    try {
      final snapshot =
          await this._firebaseService.bookLoansRef.child(id).once();
      if (snapshot.value != null) {
        final bookLoan =
            this.bookLoanFromSnapshot({...snapshot.value, "id": snapshot.key});

        return bookLoan;
      }
      return null;
    } catch (e) {
      print("error on getBookLoan ${e.toString()}");
      return null;
    }
  }

  Future<void> getUserImage(UserModel user) async {
    return this._imagesService.getUserImage(user);
  }

  Future<void> getBookCover(BookModel book) async {
    return this._imagesService.getBookCover(book);
  }

  Future<void> userSelectedBookLoan(String id) async {
    final bookLoan = await this.getBookLoan(id);
    final isOwnerOfTheBook = bookLoan.fromUser.id == this._authStore.uid;
    this.setSelectedBookLoan(bookLoan);

    if (bookLoan.status == BookLoanStatus.requested) {
      this._routingStore.moveToRoute(
            APP_ROUTE.CONFIRM_LOAN.pathWithId(id),
          );
    } else if (bookLoan.status == BookLoanStatus.lend) {
      this._bookStore.setSelectedBookForDetailsId(bookLoan.book.id);
    } else if (bookLoan.status == BookLoanStatus.toReturn) {
      if (isOwnerOfTheBook || bookLoan.toReturnReaderAnswer) {
        this._bookStore.setSelectedBookForDetailsId(bookLoan.book.id);
      } else {
        this
            ._routingStore
            .replaceToGeneralRoute(DisplayMessagePage.toReturnBookToOwner(
          onConfirm: () {
            final fromUser = bookLoan.fromUser;
            this._routingStore.replaceToRoute(
                APP_ROUTE.USER_PROFILE.pathWithId(
                  fromUser.id,
                ),
                arguments: {
                  "displayContact": true,
                  "predefinedMessage":
                      "Olá ${firstNameOnly(fromUser.name)}, preciso devolver seu livro ${bookLoan.book.title}! Vamos combinar um horário e local te entregar ele?"
                });
            this.setSelectedBookLoan(null);
          },
        ));
      }
    } else if (bookLoan.status == BookLoanStatus.toDelivery) {
      if (isOwnerOfTheBook) {
        this._bookStore.setSelectedBookForDetailsId(bookLoan.book.id);
      } else {
        this
            ._routingStore
            .replaceToGeneralRoute(DisplayMessagePage.didConfirmLoanToReader(
          onConfirm: () {
            final fromUser = bookLoan.fromUser;
            this._routingStore.replaceToRoute(
                APP_ROUTE.USER_PROFILE.pathWithId(
                  fromUser.id,
                ),
                arguments: {
                  "displayContact": true,
                  "predefinedMessage":
                      "Olá ${firstNameOnly(fromUser.name)}, obrigado por emprestar o livro ${bookLoan.book.title}! Vamos combinar um horário e local para você me entregar ele?"
                });
            this.setSelectedBookLoan(null);
          },
        ));
      }
    }
  }

  Future<void> updateLoanStatus(
    BookLoanStatus status, {
    DatabaseReference ref,
  }) async {
    try {
      final bookLoanRef = ref != null ? ref : this.selectedLoanRef;
      if (bookLoanRef == null) {
        return;
      }
      await bookLoanRef.update({
        "status": status.value,
        "${status.value}At": this._firebaseService.serverTimestamp,
      });
    } catch (e) {
      print("error on updateLoanStatus $e");
    }
  }

  Future<void> didRejectLoan(
    BookLoanModel bookLoan, {
    bool shouldRedirect = true,
  }) async {
    try {
      final ref = this._firebaseService.bookLoansRef.child(bookLoan.id);
      await this.updateLoanStatus(BookLoanStatus.canceled, ref: ref);
      this.setDaysToLoan(30);

      if (shouldRedirect) {
        this
            ._routingStore
            .replaceToGeneralRoute(DisplayMessagePage.didRejectLoan(
          onConfirm: () {
            this.setSelectedBookLoan(null);
            this._routingStore.backRoute();
          },
        ));
      }
    } catch (e) {
      print("error on didRejectLoan $e");
    }
  }

  void moveToDidConfirmLoanToOwner(BookLoanModel bookLoan) {
    final toUser = bookLoan.toUser;
    this
        ._routingStore
        .replaceToGeneralRoute(DisplayMessagePage.didConfirmLoanToOwner(
      onConfirm: () {
        this._routingStore.replaceToRoute(
            APP_ROUTE.USER_PROFILE.pathWithId(
              toUser.id,
            ),
            arguments: {
              "displayContact": true,
              "predefinedMessage":
                  "Olá ${firstNameOnly(toUser.name)}, vou te emprestar o livro ${bookLoan.book.title}. Vamos combinar um horário e local para você pegar ele?",
            });
        this.setSelectedBookLoan(null);
      },
    ));
  }

  Future<void> didApproveLoan(
    BookLoanModel _bookLoan, {
    bool shouldRedirect = true,
  }) async {
    try {
      final status = BookLoanStatus.toDelivery;
      await this._firebaseService.bookLoansRef.child(_bookLoan.id).update({
        "status": status.value,
        "${status.value}At": this._firebaseService.serverTimestamp,
        "daysToLoan": this.daysToLoan,
      });

      this.setDaysToLoan(30);

      this.moveToDidConfirmLoanToOwner(_bookLoan);
    } catch (e) {
      print("error on didApproveLoan $e");
    }
  }

  Future<BookLoanModel> answeredBookLoanBooleanQuestion(
    String notificationValue, {
    bool didAccept,
  }) async {
    String key = BookLoanStatus.toReturn.value;
    if (notificationValue.contains(BookLoanStatus.toDelivery.value)) {
      key = BookLoanStatus.toDelivery.value;
    }

    final bookLoanId = notificationValue.replaceAll("${key}_", "");

    final bookLoan = await this.getBookLoan(bookLoanId);
    final bool isOwner = bookLoan.fromUser.id == this._authStore.uid;
    key += isOwner ? "OwnerAnswer" : "ReaderAnswer";

    final refPath = this._firebaseService.bookLoansRef.child(bookLoanId).path;

    Map<String, dynamic> updates = {
      "$refPath/$key": didAccept,
      "$refPath/${key}At": this._firebaseService.serverTimestamp,
    };
    this._firebaseService.scheduleRootUpdates(updates);

    if (bookLoan.status == BookLoanStatus.toDelivery) {
      if (!isOwner) {
        if (didAccept) {
          this
              ._routingStore
              .moveToGeneralRoute(DisplayMessagePage.didConfirmBookReceived(
                expireDay:
                    "${bookLoan.expireDate} (${bookLoan.daysToLoan} dias)",
                onConfirm: () {
                  this._routingStore.backRoute();
                },
              ));
        } else {
          this
              ._routingStore
              .moveToGeneralRoute(DisplayMessagePage.didNotReceivedBookLoan(
            onConfirm: () {
              this
                  ._routingStore
                  .replaceToRoute(APP_ROUTE.USER_PROFILE.pathWithId(
                    bookLoan.fromUser.id,
                  ));
            },
          ));
        }
      }
    }

    return bookLoan;
  }

  Future<void> didRequestLoan() async {
    this._setRequestLoanStatus(RequestLoanStatus.requesting);
    final minimumExecutionTime = DateTime.now().add(Duration(seconds: 3));

    final ref = this._firebaseService.bookLoansRef.push();

    try {
      final book = this._bookStore.selectedBook;
      await ref.set({
        "book": book.toMapBasic(),
        "from": book.user.toMapBasic(),
        "startedAt": this._firebaseService.serverTimestamp,
        "status": BookLoanStatus.requested.value,
        "to": this._authStore.currentUser.toMapBasic(),
      });

      await delayUntil(minimumExecutionTime, () {
        this._setRequestLoanStatus(RequestLoanStatus.success);
      });
    } catch (e) {
      print("error in didRequestLoan $e");
      this._setRequestLoanStatus(RequestLoanStatus.error);
    }
  }

  void didExitRequestingBook() {
    this._bookStore.unselectBook();
    this._routingStore.moveToMainRoute(APP_ROUTE.HOME.path);
    Future.delayed(
      Duration(seconds: 2),
      () => this._setRequestLoanStatus(RequestLoanStatus.initial),
    );
  }

  BookLoanModel getBorrowedBookLoanOfBookIfExists(String bookId) {
    return this.currentUserBorrowedBookLoans.firstWhere(
          (element) => element.book.id == bookId,
          orElse: () => null,
        );
  }

  List<BookLoanModel> getAllRequestBookLoansForBook(String bookId) {
    return this
        .currentUserLoanedBookLoans
        .where(
          (element) => element.book.id == bookId,
        )
        .toList();
  }

  BookLoanModel getLoanedBookLoanOfBookIfExists(String bookId) {
    return this.currentUserLoanedBookLoans.firstWhere(
          (element) => element.book.id == bookId,
          orElse: () => null,
        );
  }

  Future<void> searchForRelatedBookLoanRecords(BookLoanModel bookLoan) async {
    this.setIsFetchingRelatedRecords(true);
    List<BookLoanModel> relatedRecords = [];
    try {
      final snapshot = await this
          ._firebaseService
          .bookLoansRef
          .orderByChild("status_bookId")
          .equalTo("requested_${bookLoan.book.id}")
          .once();

      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) async {
          if (key != bookLoan.id) {
            final bookLoanRecord =
                this.bookLoanFromSnapshot({...value, "id": key});
            relatedRecords.add(bookLoanRecord);
          }
        });
      }
    } catch (e) {
      print("error in searchForRelatedBookLoanRecords $e");
    } finally {
      this.setRelatedBookLoanRecords(relatedRecords);
      this.setIsFetchingRelatedRecords(false);
    }
  }

  Future<void> ownerSaidHeAlreadyDelivered(BookLoanModel bookLoan) async {
    try {
      await this._firebaseService.bookLoansRef.child(bookLoan.id).update({
        "toDeliveryOwnerAnswer": true,
        "toDeliveryOwnerAnswerAt": this._firebaseService.serverTimestamp,
      });

      await this._bookStore.fetchUserBooks(this._authStore.uid);
      this._bookStore.unselectBook();
    } catch (e) {
      print("error on ownerSaidHeAlreadyDelivered $e");
    }
  }

  Future<void> readerSaidHeAlreadyReturned(BookLoanModel bookLoan) async {
    try {
      await this._firebaseService.bookLoansRef.child(bookLoan.id).update({
        "toReturnReaderAnswer": true,
        "toReturnReaderAnswerAt": this._firebaseService.serverTimestamp,
      });

      this._bookStore.unselectBook();
    } catch (e) {
      print("error on readerSaidHeAlreadyReturned $e");
    }
  }

  Future<void> readerAnticipatedLend(BookLoanModel bookLoan) async {
    try {
      final response =
          await this._sabiaApiService.readerAnticipatedLend(bookLoan.id);

      if (response?.statusCode == 200) {
        this._notificationsService.notifySuccess(response.message);
      } else {
        this._notificationsService.notifyError(response.message);
      }
    } catch (e) {
      this
          ._notificationsService
          .notifyError("Erro desconhecido. Tente novamente por favor.");
    } finally {
      this._bookStore.unselectBook();
    }
  }

  Future<void> ownerAnticipatedReturn(BookLoanModel bookLoan) async {
    try {
      final response =
          await this._sabiaApiService.ownerAnticipatedReturn(bookLoan.id);

      if (response?.statusCode == 200) {
        this._notificationsService.notifySuccess(response.message);

        await this._bookStore.fetchUserBooks(this._authStore.uid);
      } else {
        this._notificationsService.notifyError(response.message);
      }
    } catch (e) {
      this
          ._notificationsService
          .notifyError("Erro desconhecido. Tente novamente por favor.");
    } finally {
      this._bookStore.unselectBook();
    }
  }
}
