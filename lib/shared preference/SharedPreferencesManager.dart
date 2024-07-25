import 'dart:convert';
import 'package:Linguify/constants/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _keyUserData = keyUserData;

  // Singleton instance
  static final SharedPreferencesManager _instance = SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance;
  }

  SharedPreferencesManager._internal();

  Future<void> saveUserData(Map<String, dynamic> newUserData) async {
    final prefs = await SharedPreferences.getInstance();
    String? existingUserDataString = prefs.getString(_keyUserData);

    Map<String, dynamic> existingUserData = {};
    if (existingUserDataString != null) {
      existingUserData = json.decode(existingUserDataString);
    }

    // Merge new user data with existing user data
    Map<String, dynamic> mergedUserData = {...existingUserData, ...newUserData};

    await prefs.setString(_keyUserData, json.encode(mergedUserData));
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
