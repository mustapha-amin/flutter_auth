import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/tokens_storage.dart';

class DioInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("<-- Error: ${err.type}");
    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token =
        await locator.get<TokensSecureStorage>().fetchToken(TokenType.access);
    if(token!.isNotEmpty) {
      options.headers["Authorization"] = "Bearer: $token";
    }
    log("--> ${options.method} ${options.path}");
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<-- ${response.statusCode} ${response.data}");
    return handler.next(response);
  }
}
