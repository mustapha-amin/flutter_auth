import 'package:flutter_auth/core/endpoints.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/todo_service.dart';
import 'package:flutter_auth/services/tokens_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '/core/interceptors.dart';

final locator = GetIt.instance;
void setUpServices() {
  locator
    ..registerLazySingleton(
      () => Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 15),
        ),
      )..interceptors.add(DioInterceptor()),
    )
    ..registerSingleton(AuthService(dio: locator.get<Dio>()))
    ..registerSingleton(TokensSecureStorage())
    ..registerSingleton(TodoService(dio: locator.get<Dio>()));
}