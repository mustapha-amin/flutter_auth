import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/screens/home.dart';
import 'package:flutter_auth/screens/loading_screen.dart';
import 'package:flutter_auth/screens/login.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUpServices();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserStatus userStatus = ref.watch(authNotifierProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: switch (userStatus) {
        UserStatus.loading || UserStatus.initial => const LoadingScreen(),
        UserStatus.loggedIn => HomePage(),
        _ => const LoginScreen(),
      }
    );
  }
}
