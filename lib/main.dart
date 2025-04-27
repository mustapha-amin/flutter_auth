import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/screens/auth_wrapper.dart';
import 'package:flutter_auth/screens/home.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/widgets/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: ref.read(authNotifierProvider.notifier).tokenIsValid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasError) {
            return const AuthWrapper();
          } else if (snapshot.data == true) {
            return HomePage();
          } else {
            return const AuthWrapper();
          }
        },
      ),
    );
  }
}
