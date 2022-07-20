import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class LocalFilesService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String file) async {
    final path = await _localPath;
    return File('$path/$file');
  }

  Future<File> getJsonFile(String fileName) async {
    return this._getFile("$fileName.json");
  }

  Future<File> writeJsonFile(
    Map<String, dynamic> jsonFile, {
    @required String fileName,
  }) async {
    final file = await this.getJsonFile(fileName);

    // Write the file.
    return file.writeAsString(json.encode(jsonFile));
  }

  Future<Map<String, dynamic>> readJsonFile(String fileName) async {
    try {
      final file = await this.getJsonFile(fileName);
      final contents = await file.readAsString();
      return json.decode(contents);
    } catch (e) {
      return null;
    }
  }
}
