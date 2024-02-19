import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/login.dart';
import 'package:flutter_auth/screens/signup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_screen_controller.dart';



class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLogin = ref.watch(currentScreenProvider);
    return isLogin ? const LoginScreen() : const SignUpScreen();
  }
}
