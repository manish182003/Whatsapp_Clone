import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/Responsive/responsive_layout.dart';
import 'package:whatsapp_clone/screens/mobilescreenlayou.dart';
import 'package:whatsapp_clone/screens/webscreenlayout.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: Responsivelayout(
        mobilescreenlayout: MobileScreenLayout(),
        webscreenlayout: WebScreenLayout(),
      ),
    );
  }
}
