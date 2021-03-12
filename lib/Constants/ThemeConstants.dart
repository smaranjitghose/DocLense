import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.white;
}

final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.black, backgroundColor: AppTheme.primaryColor),
    dividerColor: Colors.black12,
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.black,
        textTheme: TextTheme(
            headline6: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
        ))));

final lightTheme = ThemeData(
    primaryColor: AppTheme.primaryColor,
    brightness: Brightness.light,
    backgroundColor: Colors.blueGrey[100],
    accentColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white, backgroundColor: Colors.blue[600]),
    dividerColor: AppTheme.primaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.primaryColor),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.blue[600],
        iconTheme: const IconThemeData(
          color: AppTheme.primaryColor,
        ),
        textTheme: const TextTheme(
            headline6: TextStyle(
          color: AppTheme.primaryColor,
          // fontFamily: 'Nunito',
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
        ))));
