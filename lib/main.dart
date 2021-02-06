import 'package:doclense/About.dart';
import 'package:doclense/Home.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'dart:ui';


void main() {
  runApp(new MaterialApp(
    home: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/logos.png'),
        nextScreen: Home(),
        splashTransition: SplashTransition.rotationTransition,
        duration: 4000,
      ),
    );
  }
}
