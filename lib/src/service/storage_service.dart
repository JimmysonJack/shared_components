import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class StorageService {
  static StorageService? _instance;
  User? _user;

  static StorageService get get {
    _instance ??= StorageService();
    return _instance!;
  }

  User setUser(user) => _user = User.fromJson(user);

  User? get user => _user;

  static Future<dynamic> getJson(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? d = prefs.getString(key);
    if (d != null) {
      return jsonDecode(d);
    }
    return {};
  }

  static void setJson(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(data));
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<String> setString(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
    return data;
  }

  static Future<String?> getToken(String key) async => await getString(key);

  static Future<dynamic> getUser() async => await getJson('user');

  static get principalUser async => await getJson('principal_user');

  static Future<bool> setDarkTheme(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    return value;
  }

  static Future<bool?> getDarkMode(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
