import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._internal();
  static final SpUtil _instance = SpUtil._internal();

  factory SpUtil() {
    return _instance;
  }

  SharedPreferences? prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return prefs!.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = prefs?.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setBool(String key, bool val) {
    return prefs!.setBool(key, val);
  }

  bool? getBool(String key) {
    return prefs!.getBool(key);
  }

  Future<bool> remove(String key) {
    return prefs!.remove(key);
  }
}