import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menatal_health_journal/themes/dark_mode.dart';
import 'package:menatal_health_journal/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeProvider() {
    _loadThemePreference(); // Load theme when app starts
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkTheme;

  // Toggle theme and save preference
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeData = isDarkMode ? lightTheme : darkTheme;
    await prefs.setBool('darkMode', _themeData == darkTheme); // Save preference
    notifyListeners();
  }

  // Load saved theme from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('darkMode') ?? false;
    _themeData = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }
}
