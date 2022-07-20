import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';
import 'package:sabia_app/model/book/book_loan_model.dart';
import 'package:sabia_app/model/notification_model.dart';
import 'package:sabia_app/services/firebase_service.dart';
import 'package:sabia_app/stores/auth_store.dart';
import 'package:sabia_app/stores/book_loan_store.dart';
part 'notifications_store.g.dart';

class NotificationsStore = _NotificationsStoreBase with _$NotificationsStore;

abstract class _NotificationsStoreBase with Store {
  final AuthStore _authStore;
  final BookLoanStore _bookLoanStore;
  final FirebaseService _firebaseService;

  dynamic _notificationsListListener;

  _NotificationsStoreBase(
    this._authStore,
    this._bookLoanStore,
    this._firebaseService,
  ) {
    reaction((_) => this._authStore.isAuthenticated, (bool isAuthenticated) {
      if (isAuthenticated) {
        this._getNotifications();
      } else {
        this._clearStore();
      }
    }, fireImmediately: true);
  }

  @observable
  bool isFetching = false;

  @observable
  ObservableList<NotificationModel> notificationsList =
      ObservableList<NotificationModel>();

  @action
  void _clearStore() {
    this.notificationsList.clear();

    _notificationsListListener?.cancel();
  }

  @action
  setIsFetching(bool newValue) => this.isFetching = newValue;

  @action
  setNotificationsList(List<NotificationModel> newList) {
    this.notificationsList =
        newList.where((n) => n.isEnabled).toList().asObservable();
  }

  @action
  didReadMessage(String id) {
    final notification = this.getNotificationById(id);
    notification.isRead = true;
  }

  DatabaseReference get _baseRef => this._authStore.uid == null
      ? null
      : this._firebaseService.notificationsRef.child(this._authStore.uid);

  @computed
  int get unreadCount =>
      this.notificationsList.where((n) => !n.isRead).toList().length;

  @computed
  bool get hasAnyUnread => this.unreadCount > 0;

  void notifyWasUpdated(NotificationModel modifiedNotification) {
    // We need to do it so MobX Observer is notified to update itself
    this.setNotificationsList(this
        .notificationsList
        .map(
          (n) => n.id == modifiedNotification.id ? modifiedNotification : n,
        )
        .toList());
  }

  NotificationModel getNotificationById(String id) {
    return this.notificationsList.firstWhere(
        (notification) => notification.id == id,
        orElse: () => null);
  }

  void _getNotifications() async {
    this.setIsFetching(true);
    if (this._baseRef == null) {
      return;
    }

    this._notificationsListListener?.cancel();
    this._notificationsListListener = this
        ._baseRef
        .orderByChild("isEnabled")
        .equalTo(true)
        .onValue
        .listen((Event event) {
      List<NotificationModel> list = [];
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          final notification = NotificationModel.fromMap({
            ...value,
            "id": key,
          });
          list.add(notification);
        });
      }

      list.sort((a, b) => a.updatedAt.compareTo(b.updatedAt) * -1);

      this.setNotificationsList(list);
      this.setIsFetching(false);
    });
  }

  Future<void> userSelectedBookLoan(
    String notificationValue, {
    String replacing,
  }) async {
    final bookLoanId = notificationValue.replaceAll(replacing, "");
    await this._bookLoanStore.userSelectedBookLoan(bookLoanId);
  }

  _didSelectLinkNotification(String value) async {
    if (value.contains(BookLoanStatus.requested.value)) {
      await this.userSelectedBookLoan(
        value,
        replacing: "${BookLoanStatus.requested.value}_",
      );
    } else if (value.contains(BookLoanStatus.toDelivery.value)) {
      await this.userSelectedBookLoan(
        value,
        replacing: "${BookLoanStatus.toDelivery.value}_",
      );
    } else if (value.contains(BookLoanStatus.lend.value)) {
      await this.userSelectedBookLoan(
        value,
        replacing: "${BookLoanStatus.lend.value}_",
      );
    } else if (value.contains(BookLoanStatus.toReturn.value)) {
      await this.userSelectedBookLoan(
        value,
        replacing: "${BookLoanStatus.toReturn.value}_",
      );
    }
  }

  Future<void> didSelect(
    NotificationModel notification, {
    bool isSecondaryAction = false,
  }) async {
    if (notification.isLink) {
      await this._didSelectLinkNotification(notification.value);

      this.didRead(notification);
    } else if (notification.isBoolean) {
      await this._bookLoanStore.answeredBookLoanBooleanQuestion(
            notification.value,
            didAccept: !isSecondaryAction,
          );
    }
  }

  Future<void> didSelectAlreadyRead(
    NotificationModel notification, {
    bool isSecondaryAction = false,
  }) async {
    if (notification.isUnread) return;

    if (notification.isLink) {
      await this._didSelectLinkNotification(notification.value);
    }
  }

  void didRead(NotificationModel notification) {
    if (this._baseRef == null) {
      return;
    }

    notification.isRead = true;
    this.notifyWasUpdated(notification);

    final refPath = this._baseRef.child(notification.id).path;
    Map<String, dynamic> updates = {
      "$refPath/isRead": true,
      "$refPath/updatedAt": this._firebaseService.serverTimestamp,
    };
    this._firebaseService.scheduleRootUpdates(updates);
  }

  void didArchive(NotificationModel notification) {
    if (this._baseRef == null) {
      return;
    }

    final refPath = this._baseRef.child(notification.id).path;

    notification.isEnabled = false;
    notification.isRead = true;
    this.notifyWasUpdated(notification);

    Map<String, dynamic> updates = {
      "$refPath/isEnabled": false,
      "$refPath/isRead": true,
      "$refPath/updatedAt": this._firebaseService.serverTimestamp,
    };

    this._firebaseService.scheduleRootUpdates(updates);
  }
}
