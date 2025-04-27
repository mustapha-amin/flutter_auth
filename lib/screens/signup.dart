import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/utils/extensions.dart';
import 'package:flutter_auth/widgets/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_screen_controller.dart';
import '../utils/spacing.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return ref.watch(authNotifierProvider) == UserStatus.loading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Sign Up"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter your email",
                      decoration: InputDecoration(hintText: "email"),
                    ),
                    TextFormField(
                      controller: usernameController,
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter your username",
                      decoration: InputDecoration(hintText: "username"),
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter your password",
                      decoration: InputDecoration(hintText: "password"),
                    ),
                    sbH(50),
                    SizedBox(
                      width: context.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ref.read(authNotifierProvider.notifier).signUp(
                                  context,
                                  emailController.text.trim(),
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                );
                          } else {
                            setState(() {
                              _autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),
                    Text.rich(
                      TextSpan(text: "Already have an account? ", children: [
                        TextSpan(
                          text: "Log In",
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => toggleCurrentScreen(ref),
                        )
                      ]),
                    )
                  ],
                ).padAll(20),
              ),
            ),
          );
  }
}
