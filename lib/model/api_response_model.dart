import 'package:meta/meta.dart';

class ApiResponse {
  int statusCode;
  dynamic data;
  String message = "";

  ApiResponse({@required this.statusCode, this.data, this.message});

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, data: $data, message: $message)';
}
