import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/utils/debounce.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Map<String, dynamic> scheduledUpdates = {};

  Map<String, String> get serverTimestamp => ServerValue.timestamp;

  DatabaseReference get rootRef => this.database.reference();
  DatabaseReference get usersRef => this.rootRef.child("users");
  DatabaseReference get userFriendsRef => this.rootRef.child("userFriends");
  DatabaseReference get userDevicesRef => this.rootRef.child("userDevices");
  DatabaseReference get isbnRef => this.rootRef.child("isbn");
  DatabaseReference get authorsRef => this.rootRef.child("authors");
  DatabaseReference get booksRef => this.rootRef.child("books");
  DatabaseReference get bookReviewsRef => this.rootRef.child("bookReviews");
  DatabaseReference get userReviewsOfBooksRef =>
      this.rootRef.child("userReviewsOfBooks");
  DatabaseReference get notificationsRef => this.rootRef.child("notifications");
  DatabaseReference get bookLoansRef => this.rootRef.child("bookLoans");

  Future<void> applyRootRefUpdates(Map<String, dynamic> updates) async {
    try {
      await this.rootRef.update(updates);
    } catch (e) {
      debugPrint("error on _setRootRefUpdates $e");
    }
  }

  void dispatchScheduledRootUpdates() {
    if (this.scheduledUpdates.isEmpty) {
      return;
    }

    this.applyRootRefUpdates(this.scheduledUpdates);
    this.scheduledUpdates.clear();
  }

  void scheduleRootUpdates(
    Map<String, dynamic> updates, {
    int timeoutInSeconds = 2,
  }) {
    this.scheduledUpdates.addAll(updates);
    Debounce.seconds(timeoutInSeconds ?? 2, this.dispatchScheduledRootUpdates);
  }

  Future<void> deleteFileFromStorage(fullPath) async {
    debugPrint("FirebaseStorage: deleting file -> $fullPath");
    return await this.storage.ref().child(fullPath).delete();
  }

  Future<String> uploadToStorage({
    String fullPath,
    Uint8List data,
    File file,
    Function(StorageUploadTask, StorageTaskEvent, StorageReference)
        listenerCallback,
  }) async {
    assert(
      data != null || file != null,
      "Must provide either data or file",
    );
    debugPrint("FirebaseStorage: uploadToStorage -> $fullPath");
    final StorageReference _fileRef = this.storage.ref().child(fullPath);
    final StorageUploadTask _uploadTask =
        file != null ? _fileRef.putFile(file) : _fileRef.putData(data);

    if (listenerCallback != null) {
      _uploadTask.events.listen((StorageTaskEvent event) => listenerCallback(
            _uploadTask,
            event,
            _fileRef,
          ));
    }

    final StorageTaskSnapshot onCompleteSnapshot = await _uploadTask.onComplete;
    if (_uploadTask.isSuccessful) {
      debugPrint("FirebaseStorage: upload complete with success");
      return await onCompleteSnapshot.ref.getDownloadURL();
    }
    debugPrint("FirebaseStorage: upload failed");
    return "";
  }
}
