import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/tokens_storage.dart';

class DioInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("<-- Error: ${err.response!.statusCode}}");
    final options = err.response!.requestOptions;
    final authService = locator.get<AuthService>();
    String? newToken;
    if (err.response!.statusCode == 401) {
      log("expired or invalid access token");
      await authService.refreshToken();
      newToken =
          await locator.get<TokensSecureStorage>().fetchToken(TokenType.access);
      options.headers['Authorization'] = 'Bearer $newToken';
      return handler.resolve(await locator.get<Dio>().fetch(options));
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
