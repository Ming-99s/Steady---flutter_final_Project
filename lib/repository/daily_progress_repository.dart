import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/dialyProgress.dart';
import '../models/habbitProgress.dart';

class DailyProgressRepository extends ChangeNotifier {
  static const String _boxName = 'daily_progress';

  Box<DailyProgress> get _box => Hive.box<DailyProgress>(_boxName);

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
    return _box.values.where((p) => p.habitId == habitId).toList()
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

HabitProgress calculateHabitProgress(String habitId, List<int> newSchedule) {
  final all = getAllForHabit(habitId)..sort((a, b) => a.date.compareTo(b.date));

  int currentStreak = 0;
  int bestStreak = 0;
  int completionCount = 0;

  DateTime? previousDate;
  final today = DateTime.now();

  for (final progress in all) {
    // Count old entries as-is
    if (progress.date.isBefore(today)) {
      if (progress.isCompleted) {
        completionCount++;
        currentStreak++;
        bestStreak = bestStreak > currentStreak ? bestStreak : currentStreak;
      } else {
        currentStreak = 0;
      }
      previousDate = progress.date;
      continue;
    }

    // From today onward, use new schedule
    if (!newSchedule.contains(progress.date.weekday)) {
      previousDate = null; // skip non-scheduled days
      continue;
    }

    if (progress.isCompleted) {
      completionCount++;
      if (previousDate == null ||
          progress.date.difference(previousDate).inDays ==
              getNextScheduledDayGap(previousDate, newSchedule)) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }

      bestStreak = bestStreak > currentStreak ? bestStreak : currentStreak;
      previousDate = progress.date;
    } else {
      previousDate = null;
      currentStreak = 0;
    }
  }

  return HabitProgress(
    habitId: habitId,
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    completionCount: completionCount,
  );
}

int getNextScheduledDayGap(DateTime prev, List<int> schedule) {
  final sorted = [...schedule]..sort();
  int prevWeekday = prev.weekday;

  for (final day in sorted) {
    if (day > prevWeekday) return day - prevWeekday;
  }
  return 7 - prevWeekday + sorted.first;
}


}
