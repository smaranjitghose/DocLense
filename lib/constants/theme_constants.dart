import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.white;
}

final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    colorScheme: const ColorScheme.dark(
      secondary: Colors.white,
    ),
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
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
      ),
    ));

final lightTheme = ThemeData(
    primaryColor: AppTheme.primaryColor,
    brightness: Brightness.light,
    backgroundColor: Colors.blueGrey[100],
    colorScheme: const ColorScheme.light(
      secondary: Colors.black,
    ),
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
      titleTextStyle: const TextStyle(
        color: AppTheme.primaryColor,
        // fontFamily: 'Nunito',
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
      ),
      toolbarTextStyle: const TextStyle(
        color: AppTheme.primaryColor,
        // fontFamily: 'Nunito',
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
      ),
    ));
