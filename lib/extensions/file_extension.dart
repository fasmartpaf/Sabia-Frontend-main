import 'dart:io';

extension FileExtention on FileSystemEntity {
  String get name => this?.path?.split("/")?.last;
  String get fileExtension => this.name.split(".")?.last;
}
