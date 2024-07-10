import "dart:async";
import "dart:developer";
import "dart:io";

import "package:doclense/configs/app.dart";
import "package:doclense/constants/theme_constants.dart";
import "package:doclense/env.dart";
import "package:doclense/models/preferences.dart";
import "package:doclense/providers/theme_provider.dart";
import "package:doclense/screens/intro_screen.dart";
import "package:doclense/services/route_page.dart" as route_page;
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:path_provider/path_provider.dart" as path;
import "package:provider/provider.dart";
import "package:wiredash/wiredash.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Getting the documents directory to store the HiveDB instance
  final Directory directory = await path.getApplicationDocumentsDirectory();

  // Initializing the HiveDB
  Hive.init(directory.path);

  await Hive.openBox("pdfs");
  await Hive.openBox("starred");
  Hive.registerAdapter(UserPreferencesAdapter());
  final Box<dynamic> res = await Hive.openBox<dynamic>("preferences");
  try {
    if (res.isEmpty) {
      await res.add(UserPreferences(firstTime: true, darkTheme: false));
    }
  } on Exception catch (e) {
    await res.add(UserPreferences(firstTime: true, darkTheme: false));

    log("Exception $e");
  }

  try {
    if (Hive.box("pdfs").isEmpty) {
      await Hive.box("pdfs").add(<dynamic>[]);
    }
  } on Exception catch (e) {
    await Hive.box("pdfs").add(<dynamic>[]);
    log("Exception $e");
  }

  try {
    if (Hive.box("starred").isEmpty) {
      await Hive.box("starred").add(<dynamic>[]);
    }
  } on Exception catch (e) {
    await Hive.box("starred").add(<dynamic>[]);
    log("Exception $e");
  }

  final UserPreferences r = res.getAt(0) as UserPreferences;
  debugPrint("First Time : ${r.firstTime}");

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void dispose() {
    unawaited(Hive.box("preferences").close());
    unawaited(Hive.box("pdfs").close());
    unawaited(Hive.box("preferences").close());
    unawaited(Hive.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<DarkThemeProvider>(
        create: (_) => themeChangeProvider,
        child: Consumer<DarkThemeProvider>(
          builder:
              (BuildContext context, DarkThemeProvider value, Widget? child) =>
                  GestureDetector(
            child: Wiredash(
              theme: WiredashThemeData(
                brightness: themeChangeProvider.darkTheme
                    ? Brightness.dark
                    : Brightness.light,
              ),
              projectId: Env.wiredashID,
              secret: Env.wiredashSecret,
              child: MaterialApp(
                navigatorKey: _navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: (themeChangeProvider.darkTheme) ? darkTheme : lightTheme,
                home: const IntroScreen(),
                builder: (BuildContext context, Widget? child) {
                  App.init(context);
                  return child ?? const Scaffold();
                },
                onGenerateRoute: route_page.generateRoute,
              ),
            ),
          ),
        ),
      );
}
