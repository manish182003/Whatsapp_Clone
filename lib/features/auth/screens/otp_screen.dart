import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OTPSCREEN extends ConsumerWidget {
  static const String route = '/otp-screen';
  final String vericationid;
  const OTPSCREEN({
    Key? key,
    required this.vericationid,
  }) : super(key: key);

  void verifyotp(WidgetRef ref, BuildContext context, String userotp) {
    ref.read(authcontrollerprovider).verifyotp(
          context,
          vericationid,
          userotp,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text('We have sent an SMS with a code.'),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(fontSize: 30),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    print('verifying otp');
                    verifyotp(ref, context, value.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
