import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/spacing.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: Form(
        autovalidateMode: _autovalidateMode,
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              validator: (value) =>
                  value!.isNotEmpty ? null : "Enter your username",
            ),
            TextFormField(
              controller: passwordController,
              validator: (value) =>
                  value!.isNotEmpty ? null : "Enter your password",
            ),
            sbH(50),
            SizedBox(
              width: context.width,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(authNotifierProvider.notifier).logIn(
                          context,
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        );
                  } else {
                    setState(() {
                      _autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                child: const Text("Log In"),
              ),
            ),
            Text.rich(
              TextSpan(text: "Don't have an account? ", children: [
                TextSpan(
                  text: "Sign Up",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () => toggleCurrentScreen(ref),
                )
              ]),
            )
          ],
        ).padAll(20),
      ),
    );
  }
}
