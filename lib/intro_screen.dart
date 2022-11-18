import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/constants/assets.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'models/preferences.dart';
import 'providers/theme_provider.dart';

class IntoScreen extends StatefulWidget {
  const IntoScreen({super.key});

  @override
  State<IntoScreen> createState() => _IntoScreenState();
}

class _IntoScreenState extends State<IntoScreen> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  @override
  void dispose() {
    Hive.box('preferences').close();
    Hive.box('pdfs').close();
    Hive.close();
    super.dispose();
  }

  Future<void> getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider
        .darkThemePreference
        .getSharedPreferenceValue("themeMode");
  }

  // Checks if the user is opening the app for the first time.
  Future<bool> checkFirstTime() async {
    final UserPreferences userPreferences =
        Hive.box('preferences').getAt(0) as UserPreferences;

    return userPreferences.firstTime;
  }

  // Sets the firstTime flag to false , so that next time the user opens the ap
  // the Introduction Screen wont be shown.
  void setFirstTime() {
    Hive.box('preferences').putAt(0, UserPreferences(firstTime: false));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor:
          themeChangeProvider.darkTheme ? Colors.grey[900]! : Colors.white,
      splash: Padding(
        padding: EdgeInsets.fromLTRB(AppDimensions.width(10),
            AppDimensions.normalize(1), AppDimensions.normalize(1), 0),
        child: SvgPicture.asset(
          themeChangeProvider.darkTheme
              ? Assets.doclenselight
              : Assets.doclenselight,
        ),
      ),
      nextScreen: FutureBuilder(
          future: checkFirstTime(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              // if (snapshot.data == false) {
              //   return Home();
              // } else {
              return IntroductionScreen(
                // next: ,
                showNextButton: true,
                pages: [
                  PageViewModel(
                      title: "",
                      bodyWidget: const Center(
                        child: Text(
                          "An App made in 🇮🇳 with ❤️",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      image: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: SvgPicture.asset(
                              'assets/images/doclenselight.svg',
                              width: 350.0),
                        ),
                      )),
                  PageViewModel(
                      title: "",
                      bodyWidget: const Center(
                        child: Text(
                          "Scan Your Favourite Documents or Assignments on the go!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      image: Align(
                        alignment: Alignment.bottomCenter,
                        child:
                            Image.asset('assets/images/scan.jpg', width: 350.0),
                      ))
                ],
                onDone: () {
                  setFirstTime();
                  Navigator.of(context).pushReplacementNamed(
                    RouteConstants.homeScreen,
                  );
                },
                showSkipButton: true,
                skip: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),

                onSkip: () {
                  setFirstTime();
                  Navigator.of(context).pushReplacementNamed(
                    RouteConstants.homeScreen,
                  );
                },
                next: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                done: const Text('Done',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              );
              // }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      // nextScreen: Home(),
      splashTransition: SplashTransition.rotationTransition,
      duration: 4000,
    );
  }
}
