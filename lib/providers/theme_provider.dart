import 'package:doclense/Services/SharedPreferences.dart';
import 'package:flutter/material.dart';

class DarkThemeProvider with ChangeNotifier {
  SharedPreferencesService darkThemePreference = SharedPreferencesService();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = (value != null) ? value : false;
    darkThemePreference.setSharedPreferenceValue("themeMode", value);
    notifyListeners();
  }
}