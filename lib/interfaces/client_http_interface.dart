import 'package:flutter/foundation.dart';
import 'package:sabia_app/model/api_response_model.dart';

abstract class ClientHttpInterface {
  Map<String, dynamic> headers;

  setHeaders(Map<String, dynamic> headers);

  Future<ApiResponse> get(
    String url,
  );
  Future<ApiResponse> post(
    String url, {
    @required Map<String, dynamic> data,
  });

  ApiResponse readApiResponse(
    int statusCode,
    dynamic responseBody, {
    String url,
  });

  void saveErrorLog(dynamic logData);
}
