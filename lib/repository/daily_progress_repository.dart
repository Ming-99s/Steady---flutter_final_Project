import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/dialyProgress.dart';


class DailyProgressRepository extends ChangeNotifier {
  static const String _boxName = 'daily_progress';

  Box<DailyProgress> get _box => Hive.box<DailyProgress>(_boxName);

  /// Gets today's progress for a habit.
  /// If none exists, creates and SAVES a new one with defaults.
  DailyProgress getToday(String habitId) {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);
    final key = _key(habitId, dateOnly);

    final existing = _box.get(key);
    if (existing != null) {
      return existing;
    }

    // Create new one if not found
    final newProgress = DailyProgress(
      habitId: habitId,
      date: dateOnly,
      completedUnits: 0,
      isCompleted: false,
    );

    // IMPORTANT: Save it immediately!
    _box.put(key, newProgress);

    return newProgress;
  }

  /// Upsert (update or insert) a DailyProgress entry
  Future<void> upsert(DailyProgress progress) async {
    final key = _key(progress.habitId, progress.date);
    await _box.put(key, progress);
    notifyListeners(); // Safe even without listeners
  }

  /// Get all progress entries for a specific habit (useful for streaks/charts)
  List<DailyProgress> getAllForHabit(String habitId) {
    return _box.values
        .where((p) => p.habitId == habitId)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // Optional: sort by date
  }

  /// Helper to generate consistent keys
  String _key(String habitId, DateTime date) {
    final d =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${habitId}_$d';
  }

  /// Optional: Clear all data (for testing/logout)
  Future<void> clearAll() async {
    await _box.clear();
    notifyListeners();
  }
}