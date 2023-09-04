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
  final Box res = await Hive.openBox("preferences");
  try {
    res.getAt(0) as UserPreferences;
  } catch (e) {
    print("Exception");
    await res.add(UserPreferences(firstTime: true, darkTheme: false));
  }

  try {
    Hive.box("pdfs").getAt(0);
  } catch (e) {
    await Hive.box("pdfs").add(<dynamic>[]);
  }

  try {
    Hive.box("starred").getAt(0);
  } catch (e) {
    await Hive.box("starred").add(<dynamic>[]);
  }

  final UserPreferences r = res.getAt(0) as UserPreferences;
  print("First Time : ${r.firstTime}");

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void dispose() {
    Hive.box("preferences").close();
    Hive.box("pdfs").close();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
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
                home: const IntoScreen(),
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
