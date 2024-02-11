import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/home.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/tokens_storage.dart';
import 'package:flutter_auth/utils/dialog.dart';
import 'package:flutter_auth/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final currentScreenProvider = StateProvider((ref) {
  return true;
});

void toggleCurrentScreen(WidgetRef ref) {
  final isLogin = ref.watch(currentScreenProvider);
  ref.read(currentScreenProvider.notifier).state = !isLogin;
}

enum UserStatus {
  loggedIn,
  loggedOut,
  loading,
  initial,
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
    String? token = await tokensSecureStorage.fetchToken(TokenType.access);
    if (token!.isNotEmpty) {
      state = JwtDecoder.isExpired(token)
          ? UserStatus.loggedOut
          : UserStatus.loggedIn;
    } else {
      state = UserStatus.loggedOut;
    }
  }

  void logIn(BuildContext? context, String? username, String? password) async {
    state = UserStatus.loading;
    final res = await authService.signIn(username, password);
    res.fold(
      (l) => {
        state = UserStatus.initial,
        showErrorDialog(context: context, message: l),
      },
      (r) => {
        state = UserStatus.loggedIn,
        tokensSecureStorage.saveToken(TokenType.access, r.data!.accessToken!),
        tokensSecureStorage.saveToken(TokenType.refresh, r.data!.refreshToken!),
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
        state = UserStatus.initial,
        showErrorDialog(context: context, message: l),
      },
      (r) => {
        state = UserStatus.loggedIn,
        logIn(context, username, password),
      },
    );
  }

  void logOut(BuildContext? context) async {
    final res = await authService.logOut();
    res.fold(
      (l) => showErrorDialog(context: context, message: l),
      (r) => {
        tokensSecureStorage.clearStoredTokens(),
        state = UserStatus.loggedOut,
        context!.replace(HomePage()),
      },
    );
  }
}
