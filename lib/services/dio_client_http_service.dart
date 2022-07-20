import 'package:sabia_app/interfaces/client_http_interface.dart';
import 'package:dio/dio.dart';

import 'package:sabia_app/model/api_response_model.dart';

class DioClientHttpService implements ClientHttpInterface {
  Map<String, dynamic> headers;

  @override
  setHeaders(Map<String, dynamic> headers) {
    this.headers = headers;
  }

  @override
  Future<ApiResponse> get(String url) async {
    try {
      Response response = await Dio().get(
        url,
        options: Options(
          headers: this.headers,
        ),
      );

      return this.readApiResponse(
        response?.statusCode ?? 500,
        response.data,
        url: url,
      );
    } on DioError catch (error) {
      if (error.response != null) {
        return this.readApiResponse(
          error.response?.statusCode ?? 500,
          error.response.data,
          url: url,
        );
      } else {
        this.saveErrorLog({
          "method": url,
          "originError": error.toString(),
          "comment": "catchError block"
        });
      }

      return ApiResponse(statusCode: 403, message: "Access Denied");
    }
  }

  @override
  Future<ApiResponse> post(
    String url, {
    Map<String, dynamic> data,
  }) async {
    try {
      final response = await Dio().post(
        url,
        data: data,
        options: Options(
          headers: this.headers,
        ),
      );

      return this.readApiResponse(
        response?.statusCode ?? 500,
        response.data,
        url: url,
      );
    } on DioError catch (error) {
      if (error.response != null) {
        return this.readApiResponse(
          error.response?.statusCode ?? 500,
          error.response.data,
          url: url,
        );
      } else {
        this.saveErrorLog({
          "method": url,
          "originError": error.toString(),
          "comment": "catchError block"
        });
      }

      return ApiResponse(statusCode: 403, message: "Access Denied");
    }
  }

  @override
  ApiResponse readApiResponse(
    int statusCode,
    dynamic responseBody, {
    String url,
  }) {
    if (statusCode == 403) {
      // FORBIDDEN / ACCESS DENIED
      this.saveErrorLog({
        "statusCode": statusCode,
        "method": url,
        "response": responseBody,
        "comment": "403 error access denied"
      });
    } else if (statusCode > 299) {
      this.saveErrorLog({
        "statusCode": statusCode,
        "method": url,
        "response": responseBody,
        "comment": "Generic error"
      });
    }

    var message = "";
    if (responseBody is Map<String, dynamic>) {
      if (responseBody["error"] != null) {
        message = responseBody["error"];
      } else if (responseBody["message"] != null) {
        message = responseBody["message"];
      }
    }

    return ApiResponse(
      data: responseBody,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  void saveErrorLog(dynamic logData) {
    print("error $logData");
  }
}
