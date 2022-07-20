import 'package:pedantic/pedantic.dart';

import '../interfaces/client_http_interface.dart';
import '../interfaces/crash_report_service_interface.dart';
import '../model/api_response_model.dart';
import '../stores/auth_store.dart';

enum API_METHODS {
  isbn,
  userFeedBooks,
  readerAnticipatedLend,
  ownerAnticipatedReturn,
  verifyAndFixDuplicatedUserWithPhoneNumber,
  thereAreValidUsersForPhones,
}

extension API_METHODSExtension on API_METHODS {
  String get path {
    switch (this) {
      case API_METHODS.isbn:
        return "isbn/";
      case API_METHODS.userFeedBooks:
        return "feed/read";
      case API_METHODS.readerAnticipatedLend:
        return "book/reader-anticipated-lend";
      case API_METHODS.ownerAnticipatedReturn:
        return "book/owner-anticipated-return";
      case API_METHODS.verifyAndFixDuplicatedUserWithPhoneNumber:
        return "user/verify-and-fix-duplicated-with-phone-number";
      case API_METHODS.thereAreValidUsersForPhones:
        return "user/there-are-valid-users-for-phones";
      default:
        return "/";
    }
  }
}

class SabiaApiService {
  final ClientHttpInterface _clientHttpService;
  final CrashReportServiceInterface _crashReportService;
  final bool isProductionServer;
  AuthStore _authStore;

  SabiaApiService(
    this._clientHttpService,
    this._crashReportService, {
    this.isProductionServer,
  });

  void setStores(AuthStore authStore) {
    this._authStore = authStore;
  }

  String get serverUrl {
    if (this.isProductionServer) {
      return "us-central1-sabia-biblioteca-colaborativa.cloudfunctions.net/api";
    }
    return "us-central1-sabia-dev.cloudfunctions.net/api";
  }

  String get apiToken {
    final token = this._authStore?.apiToken ?? "";
    // print("token: $token");

    return token;
  }

  String _getUrlForMethod(API_METHODS method) =>
      "https://${this.serverUrl}/${method.path}";

  Object get _getHeaders => {
        "Accept": "application/json",
        "Content-type": "application/json",
        "charset": "utf-8",
        "Authorization": "Bearer ${this.apiToken}",
      };

  Future<ApiResponse> _getPrivateMethod(
    API_METHODS method, {
    String subPath,
  }) {
    String path = _getUrlForMethod(
      method,
    );
    if (subPath != null) {
      path += subPath;
    }

    unawaited(this._crashReportService.setValue(
          path,
          key: "_getPrivateMethod: path",
        ));
    unawaited(this._crashReportService.setValue(
          this.apiToken,
          key: "apiToken",
        ));
    this._clientHttpService.setHeaders(this._getHeaders);
    return this._clientHttpService.get(path);
  }

  Future<ApiResponse> _postPrivateMethod(
    API_METHODS method, {
    Map<String, dynamic> body,
  }) {
    String path = _getUrlForMethod(
      method,
    );
    unawaited(this._crashReportService.setValue(
          path,
          key: "_postPrivateMethod",
        ));
    unawaited(this._crashReportService.setValue(
          this.apiToken,
          key: "apiToken",
        ));
    this._clientHttpService.setHeaders(this._getHeaders);
    return this._clientHttpService.post(path, data: body);
  }

  Future<ApiResponse> _tryToGetPrivateMethod(
    API_METHODS method, {
    String subPath,
  }) async {
    ApiResponse apiResponse;
    int retry = 0;
    do {
      await this._authStore.reloadUser();
      apiResponse = await this._getPrivateMethod(method, subPath: subPath);
      retry++;
    } while (apiResponse?.statusCode == 401 && retry < 10);

    if (apiResponse?.statusCode == 401 || apiResponse?.statusCode == 403) {
      _crashReportService.logMessage(
        "forced logout with code ${apiResponse.statusCode}",
      );

      await this._authStore.logout();
      return null;
    }

    return apiResponse;
  }

  Future<ApiResponse> _tryToPostPrivateMethod(
    API_METHODS method, {
    Map<String, dynamic> body,
  }) async {
    try {
      ApiResponse apiResponse;
      int retry = 0;
      do {
        await this._authStore.reloadUser();
        apiResponse = await this._postPrivateMethod(method, body: body);
        retry++;
      } while (apiResponse?.statusCode == 401 && retry < 10);

      return apiResponse;
    } catch (error) {
      this._clientHttpService.saveErrorLog({
        "method": method.toString(),
        "originError": error.toString(),
        "comment": "catchError block"
      });

      return ApiResponse(statusCode: 403, message: "Access Denied");
    }
  }

  Future<Map<String, dynamic>> findBook(String isbn) async {
    if (isbn == null || isbn.isEmpty) return null;

    unawaited(this._crashReportService.setValue(isbn, key: "bookIsbn"));

    Map<String, dynamic> data;

    try {
      final response = await this._tryToGetPrivateMethod(
        API_METHODS.isbn,
        subPath: isbn,
      );

      if (response?.statusCode == 404) {
        return null;
      }
      if (response.data is Map<String, dynamic>) {
        data = Map<String, dynamic>.from(response.data);
      }

      return data;
    } catch (e) {
      print("error reading isbn $e");
      return null;
    }
  }

  Future<ApiResponse> getBooksForUserFeed({String searchString}) {
    return this._tryToGetPrivateMethod(
      API_METHODS.userFeedBooks,
      subPath: searchString != null && searchString.isNotEmpty
          ? "?search=$searchString"
          : null,
    );
  }

  Future<ApiResponse> readerAnticipatedLend(String bookLoanId) {
    return this._tryToPostPrivateMethod(
      API_METHODS.readerAnticipatedLend,
      body: {
        "bookLoanId": bookLoanId,
      },
    );
  }

  Future<ApiResponse> ownerAnticipatedReturn(String bookLoanId) {
    return this._tryToPostPrivateMethod(
      API_METHODS.ownerAnticipatedReturn,
      body: {
        "bookLoanId": bookLoanId,
      },
    );
  }

  Future<ApiResponse> verifyAndFixDuplicatedUserWithPhoneNumber(
    String phoneNumber,
  ) {
    return this._tryToPostPrivateMethod(
      API_METHODS.verifyAndFixDuplicatedUserWithPhoneNumber,
      body: {
        "phoneNumber": phoneNumber,
      },
    );
  }

  Future<ApiResponse> thereAreValidUsersForPhones(
    List<String> phones,
  ) {
    return this._tryToPostPrivateMethod(
      API_METHODS.thereAreValidUsersForPhones,
      body: {
        "phones": phones,
      },
    );
  }
}
