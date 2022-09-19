import 'package:flutter/material.dart';
import 'package:mixyr/state_handlers/storage/storage_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHandler extends ChangeNotifier {
  ThemeHandler? _themeHandler;
  late ThemeMode _themeMode;

  ThemeHandler({ThemeHandler? themeHandler, SharedPreferences? prefs}) {
    _themeHandler = themeHandler;
    _themeMode =
        StorageHandler().isDarkTheme == true ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeHandler?.themeMode ?? _themeMode;

  Future<void> toggleTheme() async {
    if (_themeHandler == null) {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      StorageHandler().isDarkTheme = _themeMode == ThemeMode.dark;
    } else {
      _themeHandler!.toggleTheme();
    }
    notifyListeners();
  }
}
