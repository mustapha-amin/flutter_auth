import 'package:flutter/material.dart';
import 'package:flutter_auth/utils/extensions.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.2,
          heightFactor: 0.08,
          child: Material(
            color: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: const CircularProgressIndicator().centralize(),
          ),
        ),
      ),
    );
  }
}
