import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/Responsive/responsive_layout.dart';
import 'package:whatsapp_clone/common/widget/error.dart';
import 'package:whatsapp_clone/common/widget/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/router.dart';
import 'package:whatsapp_clone/screens/mobilescreenlayou.dart';
import 'package:whatsapp_clone/screens/webscreenlayout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child:  MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp Clone',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: AppBarTheme(
              color: appBarColor,
            )),
        // Responsivelayout(
        //   mobilescreenlayout: MobileScreenLayout(),
        //   webscreenlayout: WebScreenLayout(),)
        onGenerateRoute: (settings) => generateroute(settings),
        home: ref.watch(userproviderdata).when(
          data: (user) {
            if (user == null) {
              return LandingScreen();
            }
            return MobileScreenLayout();
          },
          error: (error, stackTrace) {
            return errorscreen(error: error.toString());
          },
          loading: () {
            return loader();
          },
        ));
  }
}
