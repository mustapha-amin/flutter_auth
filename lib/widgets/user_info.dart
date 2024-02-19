import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final String value;

  const UserInfo({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$title - "),
        Text(value),
      ],
    );
  }
}
