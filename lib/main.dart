import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycantor/home/Home.dart';
import 'package:mycantor/message/SignInDetails.dart';
import 'package:mycantor/screens/AddDetails.dart';
import 'package:mycantor/screens/FirstPage.dart';
import 'package:mycantor/screens/SignIn.dart';
import 'package:mycantor/screens/finalPage.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider<SignInDetails>(
      create: (context) => SignInDetails(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
 

  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Text(
          "My Cantor",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        nextScreen: FirstPage(),
        splashTransition: SplashTransition.slideTransition,
        duration: 3000,
        backgroundColor: Color(0xff9450e7),
      ),
    );

  }
}
