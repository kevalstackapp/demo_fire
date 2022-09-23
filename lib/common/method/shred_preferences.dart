import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShredPreference {}

log(String message) {
  if (kDebugMode) {
    print(message);
  }
}

Future<bool> chekPrefKey(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future<Future<bool>> setPrefStringValue(String key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}

Future<Future<bool>> removePrefValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}
