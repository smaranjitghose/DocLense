import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
import 'package:doclense/constants/appstrings.dart';
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
    TextStyle buttonStyle = AppText.b2!.w(6).cl(Colors.black);
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
                showNextButton: true,
                pages: [
                  PageViewModel(
                      title: "",
                      bodyWidget: Text(
                        S.appMadeInIndia,
                        style: AppText.h4b,
                        textAlign: TextAlign.center,
                      ),
                      image: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: AppDimensions.width(8)),
                          child: SvgPicture.asset(
                            Assets.doclenselight,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )),
                  PageViewModel(
                      title: "",
                      bodyWidget: Text(
                        S.scanDocuments,
                        style: AppText.h4b,
                        textAlign: TextAlign.center,
                      ),
                      image: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          Assets.scanImg,
                          fit: BoxFit.fitWidth,
                        ),
                      ))
                ],
                onDone: () {
                  setFirstTime();
                  Navigator.of(context).pushReplacementNamed(
                    RouteConstants.homeScreen,
                  );
                },
                showSkipButton: true,
                skip: Text(S.skip, style: buttonStyle),
                onSkip: () {
                  setFirstTime();
                  Navigator.of(context).pushReplacementNamed(
                    RouteConstants.homeScreen,
                  );
                },
                next: Text(S.next, style: buttonStyle),
                done: Text(S.done, style: buttonStyle),
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
