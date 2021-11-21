import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => AppScreen(),
    });
  }
}

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text("Doclense",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42.0,
            )),
      ),
    );
  }
}
