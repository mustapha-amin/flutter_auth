import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_auth/core/endpoints.dart';
import 'package:flutter_auth/models/auth_response.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/tokens_storage.dart';
import 'package:fpdart/fpdart.dart';
import '../core/exceptions.dart';
import '/core/typedefs.dart';

final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

class AuthService {
  final Dio dio;
  AuthService({required this.dio});

  FutureEither<AuthResponse> signUp(
    String? email,
    String? username,
    String? password,
  ) async {
    try {
      final res = await dio.post(
        ApiEndpoints.register,
        data: {
          "email": email,
          "username": username,
          "role": "USER",
          "password": password,
        },
      );
      Map<String, dynamic> data = res.data;
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return right(authResponse);
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
      final response = await dio.post(ApiEndpoints.refreshToken, data: {
          "refreshToken": locator
              .get<TokensSecureStorage>()
              .fetchToken(TokenType.refresh),
        });
      }
      final message = handleDioException(e);
      return left(message);
    } catch (e, stck) {
      log(stck.toString(), level: 900);
      return left(e.toString());
    }
  }

  FutureEither<AuthResponse> signIn(
      String? usernameOrEmail, String? password) async {
    try {
      final res = await dio.post(
        ApiEndpoints.login,
        data: {
          emailRegex.hasMatch(usernameOrEmail!) ? "email" : "username":
              usernameOrEmail,
          "password": password,
        },
      );
      Map<String, dynamic> data = res.data;
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return right(authResponse);
    } on DioException catch (e) {
      final message = handleDioException(e);
      return left(message);
    } catch (e, stck) {
      log(stck.toString(), level: 900);
      return left(e.toString());
    }
  }

  FutureEither<String> logOut() async {
    try {
      final res = await dio.post(ApiEndpoints.logout);
      return right(res.data["message"]);
    } on DioException catch (e) {
      final message = handleDioException(e);
      return left(message);
    } catch (e, stkT) {
      log(stkT.toString());
      return left(e.toString());
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final res = await dio.get(ApiEndpoints.currentUser);
      Map<String, dynamic> data = res.data;
      return User.fromJson(data["data"]);
    } on DioException catch (e) {
      final message = handleDioException(e);
      throw Exception(message);
    } catch (e, stkT) {
      log(stkT.toString());
      throw Exception(e.toString());
    }
  }

  Future<String?> refreshToken() async {
    try {
      final res = await dio.post(ApiEndpoints.refreshToken);
      Map<String, dynamic> data = res.data;
      AuthResponse authResponse = AuthResponse.fromJson(data);
      await locator
          .get<TokensSecureStorage>()
          .saveToken(TokenType.access, authResponse.data!.accessToken!);
      await locator
          .get<TokensSecureStorage>()
          .saveToken(TokenType.refresh, authResponse.data!.refreshToken!);
      return authResponse.data!.accessToken;
    } on DioException catch (e) {
      throw Exception(handleDioException(e));
    } catch (e, stkT) {
      log(stkT.toString());
      throw Exception(e.toString());
    }
  }
}
