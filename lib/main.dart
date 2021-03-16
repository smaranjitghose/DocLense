import 'dart:ui';

import 'package:doclense/Home.dart';
import 'package:doclense/Models/preferences.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:doclense/Providers/ThemeProvider.dart';
import 'package:doclense/Constants/ThemeConstants.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Getting the documents directory to store the HiveDB instance
  final directory = await path.getApplicationDocumentsDirectory();

  // Initializing the HiveDB
  Hive.init(directory.path);

  await Hive.openBox('pdfs');
  await Hive.openBox('starred');
  Hive.registerAdapter(UserPreferencesAdapter());
  final res = await Hive.openBox('preferences');

  // try {
  //   final r = res.getAt(0) as UserPreferences;
  // } on RangeError catch (e) {
  //   print('Exception');
  //   final r = res.add(UserPreferences(firstTime: true, darkTheme: false));
  // }

  // try {
  //   final res = await Hive.box('pdfs');
  //   final r = res.getAt(0);
  // } on RangeError catch (e) {
  //   final res = await Hive.box('pdfs');
  //   final r = res.add([]);
  // }

  // try {
  //   final res = await Hive.box('starred');
  //   final r = res.getAt(0);
  // } on RangeError catch (e) {
  //   final res = await Hive.box('starred');
  //   final r = res.add([]);
  // }

  try {
    res.getAt(0) as UserPreferences;
  } catch (e) {
    print('Exception');
    res.add(UserPreferences(firstTime: true, darkTheme: false));
  }

  try {
    Hive.box('pdfs');
    res.getAt(0);
  } catch (e) {
    Hive.box('pdfs');
    res.add([]);
  }

  try {
    Hive.box('starred');
    res.getAt(0);
  } catch (e) {
    Hive.box('starred');
    res.add([]);
  }

  final r = res.getAt(0) as UserPreferences;
  print("First Time : ${r.firstTime}");


  runApp(
      //   MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: MyApp(),
      // )
      MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Hive.box('preferences').close();
    Hive.box('pdfs').close();
    Hive.close();
    super.dispose();
  }

  Future<void> getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider
        .darkThemePreference
        .getSharedPreferenceValue("themeMode") as bool;
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
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
      builder: (BuildContext context, value, Widget child) {
        return GestureDetector(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: (themeChangeProvider.darkTheme == true)
                ? darkTheme
                : lightTheme,
            home: AnimatedSplashScreen(
              backgroundColor: themeChangeProvider.darkTheme
                  ? Colors.grey[900]
                  : Colors.white,
              splash: themeChangeProvider.darkTheme
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(40, 4, 4, 0),
                      child: SvgPicture.asset('assets/doclensewhite.svg'),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(40, 4, 4, 0),
                      child:
                          SvgPicture.asset('assets/images/doclenselight.svg'),
                    ),
              nextScreen: FutureBuilder(
                  future: checkFirstTime(),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == false) {
                        return Home();
                      } else {
                        return IntroductionScreen(
                          pages: [
                            PageViewModel(
                                title: "",
                                bodyWidget: const Center(
                                  child: Text(
                                    "An App made in 🇮🇳 with ❤️",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                image: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 0, 0),
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                image: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset('assets/images/scan.jpg',
                                      width: 350.0),
                                ))
                          ],
                          onDone: () {
                            setFirstTime();
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => Home(),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  // transitionDuration: Duration(milliseconds: 1000),
                                ));
                          },
                          showSkipButton: true,
                          skip: const Text("Skip"),
                          onSkip: () {
                            setFirstTime();
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => Home(),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  // transitionDuration: Duration(milliseconds: 1000),
                                ));
                          },
                          done: const Text('Done',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              // nextScreen: Home(),
              splashTransition: SplashTransition.rotationTransition,
              duration: 4000,
            ),
          ),
        );
      },
    ));
  }
}
