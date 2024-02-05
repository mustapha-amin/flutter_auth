import 'package:dio/dio.dart';
import 'package:flutter_auth/core/endpoints.dart';
import 'package:flutter_auth/models/auth_response.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '/core/typedefs.dart';


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
          "role": "user",
          "password": password,
        },
      );
      AuthResponse authResponse = AuthResponse.fromJson(res.data);
      return right(authResponse);
    } on DioException catch (e) {
      return left(e.response!.data["message"]);
    }
  }

  FutureEither<AuthResponse> signIn(String? username, String? password) async {
    try {
      final res = await dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );
      AuthResponse authResponse = AuthResponse.fromJson(res.data);
      return right(authResponse);
    } on DioException catch (e) {
      return left(e.response!.data["message"]);
    }
  }

  FutureEither<String> logOut() async {
    try {
      final res = await dio.post(ApiEndpoints.logout);
      return right(res.data["message"]);
    } on DioException catch (e) {
      return left(e.response!.data["message"]);
    }
  }

  bool tokenIsValid(String token) {
    return JwtDecoder.isExpired(token);
  }

}