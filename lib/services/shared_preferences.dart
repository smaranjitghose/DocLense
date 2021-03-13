import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<dynamic> getSharedPreferenceValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? null;
  }

  setSharedPreferenceValue(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }
}
