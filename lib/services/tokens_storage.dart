import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum TokenType {
  access,
  refresh,
}

class TokensSecureStorage {
  final secureStorage = const FlutterSecureStorage();

  static const accessToken = "accessToken";
  static const refreshToken = "refreshToken";

  Future<void> saveToken(TokenType tokenType, String token) async {
    await secureStorage.write(
      key: tokenType == TokenType.access ? accessToken : refreshToken,
      value: token,
    );
    log((await fetchToken(TokenType.access))!);
  }

  Future<bool?> tokenExist(TokenType tokenType) async {
    bool? exists = (await fetchToken(tokenType))!.isNotEmpty;
    return exists;
  }

  Future<String?> fetchToken(TokenType tokenType) async {
    String? token = await secureStorage.read(
          key: tokenType == TokenType.access ? accessToken : refreshToken,
        ) ??
        '';
    return token;
  }

  Future<void> clearStoredTokens() async {
    await secureStorage.deleteAll();
  }
}
