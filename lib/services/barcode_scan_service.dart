import 'package:barcode_scan/barcode_scan.dart';

class BarcodeScanService {
  static Future<String> scan() async {
    return await BarcodeScanner
        .scan(); // If a unknown format was scanned this field contains a note
  }
}
