import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/screens/auth_wrapper.dart';
import 'package:flutter_auth/screens/home.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';

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
      home: Stack(
        alignment: Alignment.center,
        children: [
          switch (userStatus) {
            UserStatus.loggedIn => HomePage(),
            _ => const AuthWrapper(),
          },
          if (userStatus == UserStatus.loading)
            GestureDetector(
              onTap: () => log(ref.watch(authNotifierProvider).name),
              child: SizedBox(
                width: context.width * .2,
                height: context.width * .2,
                child: Material(
                  color: Colors.black.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const CircularProgressIndicator().centralize(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
