import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const keyFirstLaunch = 'first_launch';
  static const keyLastMoodDate = 'last_mood_date';

  // Check first launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyFirstLaunch) ?? true;
  }

  static Future<void> setFirstLaunchFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyFirstLaunch, false);
  }

  // Check if Mood done today
  static Future<bool> isMoodCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(keyLastMoodDate);
    if (dateString == null) return false;

    final lastDate = DateTime.parse(dateString);
    final now = DateTime.now();
    return lastDate.year == now.year &&
        lastDate.month == now.month &&
        lastDate.day == now.day;
  }

  static Future<void> setMoodCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastMoodDate, DateTime.now().toIso8601String());
  }
}
