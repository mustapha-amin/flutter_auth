import 'dart:developer';

import 'package:dio/dio.dart';

class DioService {
  final dio = Dio(
    BaseOptions(
      baseUrl: "https://api.freeapi.app/users",
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  DioService() {
    dio.interceptors.add(DioInterceptor());
  }
}

class DioInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("<-- Error: ${err.type}");
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("--> ${options.method} ${options.path}");
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<-- ${response.statusCode} ${response.data}");
    return handler.next(response);
  }
}
