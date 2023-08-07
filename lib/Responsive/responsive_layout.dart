import 'package:flutter/material.dart';

class Responsivelayout extends StatelessWidget {
  final Widget mobilescreenlayout;
  final Widget webscreenlayout;
  const Responsivelayout({
    Key? key,
    required this.mobilescreenlayout,
    required this.webscreenlayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return webscreenlayout;
        }
        return mobilescreenlayout;
      },
    );
  }
}
