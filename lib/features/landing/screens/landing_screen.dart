import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/common/widget/custom_button.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Welcome To WhatsApp',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height / 9,
              ),
              Image.asset(
                'assets/bg.png',
                height: 280,
                width: 280,
                color: tabColor,
              ),
              SizedBox(
                height: size.height / 9,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * .75,
                child: Custombutton(
                  text: 'AGREE AND CONTINUE',
                  onpressed: () {
                    Navigator.pushNamed(context, loginscreen.routename);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
