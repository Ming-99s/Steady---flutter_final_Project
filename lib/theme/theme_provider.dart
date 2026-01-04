import 'package:flutter/material.dart';
import 'package:steady/utils/app_pref.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    _isDarkMode = await AppPrefs.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await AppPrefs.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      brightness: Brightness.light,
      primaryColor: const Color(0xFF2563EB),
      scaffoldBackgroundColor: const Color(0xFFEFF6FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2563EB),
        secondary: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF3B82F6),
      scaffoldBackgroundColor: const Color(0xFF111827),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3B82F6),
        secondary: Color(0xFF1F2937),
        surface: Color(0xFF1F2937),
        error: Color(0xFFDC2626),
      ),
    );
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;
}
