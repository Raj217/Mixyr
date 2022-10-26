import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHandler {
  static SharedPreferences? _prefs;
  StorageHandler() {
    if (_prefs == null) {
      _initPreferences();
    }
  }

  // ----------------------- Getter Methods -----------------------------------
  SharedPreferences get getPrefs => _prefs!;
  bool get isNewUser => _prefs?.getBool('newUser') ?? true;
  bool get isDarkTheme =>
      _prefs?.getBool('isDarkTheme') ??
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  bool get isProxyEnabled => _prefs?.getBool('isProxyEnabled') ?? false;
  Future<bool> getIsProxyEnabled() async {
    await _initPreferences();
    return _prefs?.getBool('isProxyEnabled') ?? false;
  }

  // ----------------------- Setter Methods -----------------------------------
  set isNewUser(bool isNewUser) => _prefs?.setBool('newUser', isNewUser);
  set isDarkTheme(bool isDarkTheme) =>
      _prefs?.setBool('isDarkTheme-', isDarkTheme);
  set isProxyEnabled(bool isProxyEnabl) =>
      _prefs?.setBool('isProxyEnabled', isProxyEnabl);

  // ----------------------- Other Methods  -----------------------------------
  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
