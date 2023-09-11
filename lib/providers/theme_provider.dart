import "dart:async";

import "package:doclense/services/shared_preferences.dart";
import "package:flutter/material.dart";

class DarkThemeProvider with ChangeNotifier {
  SharedPreferencesService darkThemePreference = SharedPreferencesService();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool? value) {
    _darkTheme = value ?? false;
    unawaited(darkThemePreference.setSharedPreferenceValue("themeMode", value));
    notifyListeners();
  }
}
