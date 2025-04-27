import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/tokens_storage.dart';

class DioInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("<-- Error: ${err.response?.statusCode}");

    final originalRequest = err.requestOptions;

    if (err.response?.statusCode == 401) {
      try {
        log("Access token expired. Attempting to refresh...");
        final newAccessToken = await locator.get<AuthService>().refreshToken();
        if (newAccessToken == null) {
          return handler.reject(err);
        }

        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await locator.get<Dio>().fetch(originalRequest);
        return handler.resolve(retryResponse);
      } catch (e, stk) {
        log("Token refresh failed: $e\n$stk");
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token =
        await locator.get<TokensSecureStorage>().fetchToken(TokenType.access);
    if (token!.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
      log(options.headers.values.toString());
      log("--> ${options.method} ${options.path} $token");
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<-- ${response.statusCode} ${response.data}");
    return handler.next(response);
  }
}
