import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Color.dart';

class Custombutton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  const Custombutton({
    Key? key,
    required this.text,
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: tabColor,
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }
}
