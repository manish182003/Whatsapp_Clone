import 'package:flutter/material.dart';

class errorscreen extends StatelessWidget {
  final String error;
  const errorscreen({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
