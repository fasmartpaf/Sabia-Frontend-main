import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  camera,
  savePhoto,
  notifications,
  contacts,
}

enum EPermissionStatus {
  undetermined,
  granted,
  denied,
}

class UserPermissionService {
  Permission get _storagePermission {
    return Platform.isAndroid ? Permission.storage : Permission.photos;
  }

  Future<PermissionStatus> _checkPermission(
    Permission permission,
  ) async =>
      permission.status;

  Future<PermissionStatus> _requestPermission(
    Permission permission,
  ) async =>
      permission.request();

  EPermissionStatus statusAdapter(PermissionStatus status) {
    if (status == null) {
      return EPermissionStatus.denied;
    }
    switch (status) {
      case PermissionStatus.undetermined:
        return EPermissionStatus.undetermined;
      case PermissionStatus.granted:
        return EPermissionStatus.granted;
      default:
        return EPermissionStatus.denied;
    }
  }

  Future<EPermissionStatus> check(PermissionType type) async {
    Future<PermissionStatus> permission;
    switch (type) {
      case PermissionType.notifications:
        permission = _checkPermission(Permission.notification);
        break;

      case PermissionType.savePhoto:
        permission = _checkPermission(_storagePermission);
        break;

      case PermissionType.camera:
        permission = _checkPermission(Permission.camera);
        break;

      case PermissionType.contacts:
        permission = _checkPermission(Permission.contacts);
        break;
      default:
        return null;
    }

    return statusAdapter(await permission);
  }

  Future<bool> isGranted(PermissionType type) async =>
      await this.check(type) == EPermissionStatus.granted;

  Future<EPermissionStatus> request(PermissionType type) async {
    Future<PermissionStatus> permission;
    switch (type) {
      case PermissionType.notifications:
        permission = _requestPermission(Permission.notification);
        break;

      case PermissionType.savePhoto:
        permission = _requestPermission(_storagePermission);
        break;

      case PermissionType.camera:
        permission = _requestPermission(Permission.camera);
        break;

      case PermissionType.contacts:
        permission = _requestPermission(Permission.contacts);
        break;
      default:
        return null;
    }

    return statusAdapter(await permission);
  }

  Future<bool> openSettings() => openAppSettings();
}
