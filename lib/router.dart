import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widget/error.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_clone/features/contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateroute(RouteSettings settings) {
  switch (settings.name) {
    case loginscreen.routename:
      return MaterialPageRoute(
        builder: (context) => loginscreen(),
      );
    case OTPSCREEN.route:
      final verificationid = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPSCREEN(
          vericationid: verificationid,
        ),
      );
    case UserinformationScreen.routename:
      return MaterialPageRoute(
        builder: (context) => UserinformationScreen(),
      );
    case SelectContactScreen.routename:
      return MaterialPageRoute(
        builder: (context) => SelectContactScreen(),
      );
    case MobileChatScreen.routename:
      var argument = settings.arguments as Map<String, dynamic>;
      var name = argument['name'];
      final uid = argument['uid'].toString();
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: errorscreen(error: 'This Page does not exists'),
        ),
      );
  }
}
