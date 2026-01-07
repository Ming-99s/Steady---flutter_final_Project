import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyLastMoodDate = 'last_mood_date';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keySelectedMood = 'selected_mood';


  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  static Future<void> markFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
  }


  static Future<bool> isMoodCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_keyLastMoodDate);
    if (dateString == null) return false;

    final lastDate = DateTime.parse(dateString);
    final now = DateTime.now();

    return lastDate.year == now.year &&
        lastDate.month == now.month &&
        lastDate.day == now.day;
  }

  static Future<void> setMoodCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyLastMoodDate,
      DateTime.now().toIso8601String(),
    );
  }


  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }


  static Future<String?> getSelectedMood() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedMood);
  }

  static Future<void> setSelectedMood(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedMood, mood);
  }
}
