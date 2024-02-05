import 'package:flutter_auth/core/providers.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/tokens_storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setUpServices() {
  locator
    ..registerLazySingleton(() => DioService())
    ..registerSingleton(AuthService(dio: locator.get<DioService>().dio))
    ..registerSingleton(TokensSecureStorage());
}
