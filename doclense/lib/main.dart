import 'package:doclense/screens/landing_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
      '/': (context) => const AppScreen(),
    },
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  LandingPage();
  }
}