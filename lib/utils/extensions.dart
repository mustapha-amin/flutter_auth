import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget padX(double? size) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size!),
        child: this,
      );

  Widget padY(double? size) => Padding(
        padding: EdgeInsets.symmetric(vertical: size!),
        child: this,
      );

  Widget padAll(double? size) => Padding(
        padding: EdgeInsets.all(size!),
        child: this,
      );

  Widget centralize() => Center(
        child: this,
      );
}

extension BuildContextExt on BuildContext {
  void replace(Widget? screen) {
    Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => screen!));
  }

  void pop(Widget? screen) {
    Navigator.pop(this);
  }

  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
