import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../components/button/button.dart';
import '../components/icon/app_icon.dart';
import '../components/modal/modal.dart';
import '../services/user_permission_service.dart';
part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase extends Disposable with Store {
  List<ReactionDisposer> _disposersList;

  final UserPermissionService _userPermissionService;

  @observable
  EPermissionStatus notificationPermissionStatus =
      EPermissionStatus.undetermined;

  _SettingsStoreBase(this._userPermissionService) {
    this._verifyNotificationPermission();

    this._disposersList ??= [];
  }

  @override
  dispose() {
    this._disposersList?.forEach((d) => d());
  }

  clearStore() {}

  _verifyNotificationPermission() async {
    // debugPrint("_verifyNotificationPermission");
    final EPermissionStatus status =
        await _userPermissionService.check(PermissionType.notifications);
    if (this.notificationPermissionStatus != status) {
      this.setNotificationPermissionStatus(status);
    }
  }

  @action
  setNotificationPermissionStatus(EPermissionStatus newValue) =>
      this.notificationPermissionStatus = newValue;

  @computed
  bool get notificationsIsAllowed =>
      this.notificationPermissionStatus == EPermissionStatus.granted;

  @computed
  bool get notificationsIsDenied =>
      this.notificationPermissionStatus == EPermissionStatus.denied;

  _requestNotificationPermission() async {
    // EPermissionStatus status =
    //     await _userPermissionService.request(PermissionType.notifications);
    // this.setNotificationPermissionStatus(status);
  }

  void _didRequestNotificationPermission() {
    if (this.notificationsIsDenied) {
      _userPermissionService.openSettings();
      Future.delayed(
        Duration(seconds: 30),
        _verifyNotificationPermission,
      );
    } else {
      _requestNotificationPermission();
    }
  }

  void openRequestNotificationPermissionModal() {
    Modal.custom(
      title: "Configurar notificações",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            this.notificationsIsDenied
                ? "Você não está recebendo notificações de mensagens no chat ou sobre o contrato."
                : "Use o botão abaixo para receber notificações de mensagens no chat ou sobre o contrato.",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          PrimaryButton(
            label: "Configurar",
            icon: NotificationIcon,
            onPressed: () {
              Modular.to.pop();
              this._didRequestNotificationPermission();
            },
          )
        ],
      ),
      confirmButton: FlatButton(
        child: Text("OK"),
        onPressed: () => Modular.to.pop(),
      ),
    );
  }
}
