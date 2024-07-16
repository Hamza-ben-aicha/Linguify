import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _keyUserData = 'userData';

  // Singleton instance
  static final SharedPreferencesManager _instance = SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance;
  }

  SharedPreferencesManager._internal();

  // Save all user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserData, json.encode(userData));
  }

  // Get all user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString(_keyUserData);
    if (userDataString != null && userDataString.isNotEmpty) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(json.decode(userDataString));
      return userData;
    }
    return null;
  }

  // Clear all user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserData);
  }
}
