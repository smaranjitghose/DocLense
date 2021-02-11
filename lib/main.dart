import 'package:doclense/Home.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SharedPreferences sharedPreferences;

  // Checks if the user is opening the app for the first time.
  Future checkFirstTime() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getBool('firstTime') != null) return true;
    return false;
  }

  // Sets the firstTime flag to false , so that next time the user opens the ap
  // the Introduction Screen wont be shown.
  setFirstTime() {
    sharedPreferences.setBool('firstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/logos.png'),
        nextScreen: FutureBuilder(
            future: checkFirstTime(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == false) {
                  return Home();
                } else
                  return IntroductionScreen(
                    pages: [
                      PageViewModel(
                          title: "",
                          bodyWidget: Center(
                            child: Text(
                              "An App made in 🇮🇳 with ❤️",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          image: Align(
                            child: Image.asset(
                                'assets/images/logo.png', width: 350.0),
                            alignment: Alignment.bottomCenter,
                          )
                      ),

                      PageViewModel(
                          title: "",
                          bodyWidget: Center(
                            child: Text(
                              "Scan Your Favourite Documents or Assignments on the go!!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          image: Align(
                            child: Image.asset(
                                'assets/images/scan.jpg', width: 350.0),
                            alignment: Alignment.bottomCenter,
                          )
                      )
                    ],
                    onDone: () {
                      setFirstTime();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Home()
                      ));
                    },
                    showSkipButton: true,
                    skip: Text("Skip"),
                    onSkip: () {
                      setFirstTime();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Home()
                      ));
                    },
                    done: const Text(
                        'Done', style: TextStyle(fontWeight: FontWeight.w600)),
                  );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
        ),
        splashTransition: SplashTransition.rotationTransition,
        duration: 4000,
      ),
    );
  }
}
