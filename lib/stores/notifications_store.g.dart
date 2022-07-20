// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NotificationsStore on _NotificationsStoreBase, Store {
  Computed<int> _$unreadCountComputed;

  @override
  int get unreadCount =>
      (_$unreadCountComputed ??= Computed<int>(() => super.unreadCount,
              name: '_NotificationsStoreBase.unreadCount'))
          .value;
  Computed<bool> _$hasAnyUnreadComputed;

  @override
  bool get hasAnyUnread =>
      (_$hasAnyUnreadComputed ??= Computed<bool>(() => super.hasAnyUnread,
              name: '_NotificationsStoreBase.hasAnyUnread'))
          .value;

  final _$isFetchingAtom = Atom(name: '_NotificationsStoreBase.isFetching');

  @override
  bool get isFetching {
    _$isFetchingAtom.reportRead();
    return super.isFetching;
  }

  @override
  set isFetching(bool value) {
    _$isFetchingAtom.reportWrite(value, super.isFetching, () {
      super.isFetching = value;
    });
  }

  final _$notificationsListAtom =
      Atom(name: '_NotificationsStoreBase.notificationsList');

  @override
  ObservableList<NotificationModel> get notificationsList {
    _$notificationsListAtom.reportRead();
    return super.notificationsList;
  }

  @override
  set notificationsList(ObservableList<NotificationModel> value) {
    _$notificationsListAtom.reportWrite(value, super.notificationsList, () {
      super.notificationsList = value;
    });
  }

  final _$_NotificationsStoreBaseActionController =
      ActionController(name: '_NotificationsStoreBase');

  @override
  void _clearStore() {
    final _$actionInfo = _$_NotificationsStoreBaseActionController.startAction(
        name: '_NotificationsStoreBase._clearStore');
    try {
      return super._clearStore();
    } finally {
      _$_NotificationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsFetching(bool newValue) {
    final _$actionInfo = _$_NotificationsStoreBaseActionController.startAction(
        name: '_NotificationsStoreBase.setIsFetching');
    try {
      return super.setIsFetching(newValue);
    } finally {
      _$_NotificationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNotificationsList(List<NotificationModel> newList) {
    final _$actionInfo = _$_NotificationsStoreBaseActionController.startAction(
        name: '_NotificationsStoreBase.setNotificationsList');
    try {
      return super.setNotificationsList(newList);
    } finally {
      _$_NotificationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic didReadMessage(String id) {
    final _$actionInfo = _$_NotificationsStoreBaseActionController.startAction(
        name: '_NotificationsStoreBase.didReadMessage');
    try {
      return super.didReadMessage(id);
    } finally {
      _$_NotificationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isFetching: ${isFetching},
notificationsList: ${notificationsList},
unreadCount: ${unreadCount},
hasAnyUnread: ${hasAnyUnread}
    ''';
  }
}
