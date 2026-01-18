import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {

  static const String loginKey = 'isLoggedIn';
  static const String email = 'email';
  static const String fullName = 'fullName';
  static const String lastIn = 'lastIn';
  static const String lastOut = 'lastOut';

  static Future<bool?> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(fullName);
  }

  static Future<String?> getLastIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastIn);
  }

  static Future<String?> getLastOut() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastOut);
  }

}