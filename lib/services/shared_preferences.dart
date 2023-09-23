import "package:shared_preferences/shared_preferences.dart";

class SharedPreferencesService {
  Future<dynamic> getSharedPreferenceValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  Future<void> setSharedPreferenceValue(
    String key,
    // ignore: always_specify_types, type_annotate_public_apis
    value,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

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
