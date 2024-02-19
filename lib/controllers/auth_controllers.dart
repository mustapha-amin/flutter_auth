import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/auth_wrapper.dart';
import 'package:flutter_auth/screens/home.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/tokens_storage.dart';
import 'package:flutter_auth/utils/dialog.dart';
import 'package:flutter_auth/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum UserStatus {
  loggedIn,
  loggedOut,
  loading,
  initial;
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, UserStatus>((ref) {
  return AuthNotifier(
    authService: locator.get<AuthService>(),
    tokensSecureStorage: locator.get<TokensSecureStorage>(),
  );
});

class AuthNotifier extends StateNotifier<UserStatus> {
  final AuthService authService;
  final TokensSecureStorage tokensSecureStorage;
  AuthNotifier({
    required this.authService,
    required this.tokensSecureStorage,
  }) : super(UserStatus.initial) {
    tokenIsValid();
  }

  void tokenIsValid() async {
    state = UserStatus.loading;
    String? token = await tokensSecureStorage.fetchToken(TokenType.access);
    if (token!.isNotEmpty && !JwtDecoder.isExpired(token)) {
      try {
        await locator.get<AuthService>().getCurrentUser();
        state = UserStatus.loggedIn;
      } catch (e) {
        debugPrint(e.toString());
        state = UserStatus.loggedOut;
      }
    } else {
      state = UserStatus.loggedOut;
    }
  }

  void logIn(BuildContext? context, String? username, String? password) async {
    state = UserStatus.loading;
    final res = await authService.signIn(username, password);
    res.fold(
      (l) => {
        state = UserStatus.loggedOut,
        showErrorDialog(context: context, message: l),
      },
      (r) => {
        state = UserStatus.loggedIn,
        locator
            .get<TokensSecureStorage>()
            .saveToken(TokenType.access, r.data!.accessToken!),
        locator
            .get<TokensSecureStorage>()
            .saveToken(TokenType.refresh, r.data!.refreshToken!),
        context!.replace(HomePage()),
      },
    );
  }

  void signUp(BuildContext? context, String? email, String? username,
      String? password) async {
    state = UserStatus.loading;
    final res = await authService.signUp(email, username, password);
    res.fold(
      (l) => {
        state = UserStatus.loggedOut,
        showErrorDialog(context: context, message: l),
      },
      (r) async => {
        await tokensSecureStorage.saveToken(
            TokenType.access, r.data!.accessToken!),
        await tokensSecureStorage.saveToken(
            TokenType.refresh, r.data!.refreshToken!),
        logIn(context, username, password),
        state = UserStatus.loggedIn,
      },
    );
  }

  void logOut(BuildContext? context) async {
    final res = await authService.logOut();
    res.fold(
      (l) => showErrorDialog(context: context, message: l),
      (r) => {
        state = UserStatus.loggedOut,
        context!.replace(const AuthWrapper()),
      },
    );
  }
}
