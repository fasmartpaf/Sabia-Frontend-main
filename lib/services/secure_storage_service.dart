import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum STORAGE_KEYS { USER_TOKEN, CONTRACT_HASH }

class SecureStorageService {
  static Future<String> read(STORAGE_KEYS key) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: key.toString()) ?? "";
  }

  static Future<void> set({
    @required STORAGE_KEYS key,
    @required String value,
  }) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.write(key: key.toString(), value: value);
  }

  static Future<void> remove(STORAGE_KEYS key) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: key.toString());
  }
}
