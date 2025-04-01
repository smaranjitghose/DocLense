import 'package:doclense/configs/app_typography.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.white;
}

TextStyle appbarStyle = AppText.b2b != null
    ? AppText.b2b!.cl(Colors.white)
    : TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold);

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
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
  appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.black,
      titleTextStyle: appbarStyle,
      toolbarTextStyle: appbarStyle), colorScheme: const ColorScheme.dark(
    secondary: Colors.white,
  ).copyWith(background: const Color(0xFF212121)),
);

final lightTheme = ThemeData(
  primaryColor: AppTheme.primaryColor,
  brightness: Brightness.light,
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
    titleTextStyle: appbarStyle,
    toolbarTextStyle: appbarStyle,
  ), colorScheme: const ColorScheme.light(
    secondary: Colors.black,
  ).copyWith(background: Colors.blueGrey[100]),
);
