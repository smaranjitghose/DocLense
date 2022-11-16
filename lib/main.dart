import 'package:doclense/constants/theme_constants.dart';
import 'package:doclense/intro_screen.dart';
import 'package:doclense/models/preferences.dart';
import 'package:doclense/providers/theme_provider.dart';
import 'package:doclense/services/route_page.dart' as route_page;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

import 'configs/app.dart';

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
  try {
    res.getAt(0) as UserPreferences;
  } catch (e) {
    print('Exception');
    res.add(UserPreferences(firstTime: true, darkTheme: false));
  }

  try {
    Hive.box('pdfs').getAt(0);
  } catch (e) {
    Hive.box('pdfs').add([]);
  }

  try {
    Hive.box('starred').getAt(0);
  } catch (e) {
    Hive.box('starred').add([]);
  }

  final r = res.getAt(0) as UserPreferences;
  print("First Time : ${r.firstTime}");

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return GestureDetector(
          child: Wiredash(
            theme: WiredashThemeData(
              brightness: themeChangeProvider.darkTheme == true
                  ? Brightness.dark
                  : Brightness.light,
            ),
            projectId: 'doclense-sr0pzs4',
            secret: '0f4ajalausiiv0i7po2outfhtvmxy9a6dcd1o9rqk3a3ibcn',
            child: MaterialApp(
              navigatorKey: _navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: (themeChangeProvider.darkTheme == true)
                  ? darkTheme
                  : lightTheme,
              home: IntoScreen(),
              builder: (context, child) {
                App.init(context);
                return child!;
              },
              onGenerateRoute: route_page.generateRoute,
            ),
          ),
        );
      },
    ));
  }
}
