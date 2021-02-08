import 'package:doclense/About.dart';
import 'package:doclense/Home.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'dart:ui';
import 'package:doclense/Providers/ThemeProvider.dart';
import 'package:doclense/Constants/ThemeConstants.dart';
import 'package:provider/provider.dart';

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
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider
        .darkThemePreference
        .getSharedPreferenceValue("themeMode");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
            return GestureDetector(
              child: MaterialApp(
                theme: (themeChangeProvider.darkTheme == true)
                    ? darkTheme
                    : lightTheme,
                home: AnimatedSplashScreen(
                  backgroundColor: themeChangeProvider.darkTheme ? Colors
                      .grey[900] : Colors.white,
                  splash: Image.asset('assets/images/logos.png'),
                  nextScreen: Home(),
                  splashTransition: SplashTransition.rotationTransition,
                  duration: 4000,
                ),
              ),
            );
          },
        )
    );
  }
}
