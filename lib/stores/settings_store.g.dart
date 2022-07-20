// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsStore on _SettingsStoreBase, Store {
  Computed<bool> _$notificationsIsAllowedComputed;

  @override
  bool get notificationsIsAllowed => (_$notificationsIsAllowedComputed ??=
          Computed<bool>(() => super.notificationsIsAllowed,
              name: '_SettingsStoreBase.notificationsIsAllowed'))
      .value;
  Computed<bool> _$notificationsIsDeniedComputed;

  @override
  bool get notificationsIsDenied => (_$notificationsIsDeniedComputed ??=
          Computed<bool>(() => super.notificationsIsDenied,
              name: '_SettingsStoreBase.notificationsIsDenied'))
      .value;

  final _$notificationPermissionStatusAtom =
      Atom(name: '_SettingsStoreBase.notificationPermissionStatus');

  @override
  EPermissionStatus get notificationPermissionStatus {
    _$notificationPermissionStatusAtom.reportRead();
    return super.notificationPermissionStatus;
  }

  @override
  set notificationPermissionStatus(EPermissionStatus value) {
    _$notificationPermissionStatusAtom
        .reportWrite(value, super.notificationPermissionStatus, () {
      super.notificationPermissionStatus = value;
    });
  }

  final _$_SettingsStoreBaseActionController =
      ActionController(name: '_SettingsStoreBase');

  @override
  dynamic setNotificationPermissionStatus(EPermissionStatus newValue) {
    final _$actionInfo = _$_SettingsStoreBaseActionController.startAction(
        name: '_SettingsStoreBase.setNotificationPermissionStatus');
    try {
      return super.setNotificationPermissionStatus(newValue);
    } finally {
      _$_SettingsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
notificationPermissionStatus: ${notificationPermissionStatus},
notificationsIsAllowed: ${notificationsIsAllowed},
notificationsIsDenied: ${notificationsIsDenied}
    ''';
  }
}
