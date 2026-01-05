import 'package:hive/hive.dart';
import '../models/dialyProgress.dart';
import '../models/habbitProgress.dart';

class DailyProgressRepository {
  static const String _boxName = 'daily_progress';

  Box<DailyProgress> get _box => Hive.box<DailyProgress>(_boxName);

  /// Returns a clean date with no time
  DateTime getTodayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get today's progress for a habit, or create it if missing
  DailyProgress getToday(String habitId) {
    final today = getTodayDate();
    final key = _key(habitId, today);

    final existing = _box.get(key);
    if (existing != null) return existing;

    final newProgress = DailyProgress(
      habitId: habitId,
      date: today,
      completedUnits: 0,
      isCompleted: false,
    );

    _box.put(key, newProgress);
    return newProgress;
  }

  /// Upsert a progress entry (update or insert)
  Future<void> upsert(DailyProgress progress) async {
    final key = _key(progress.habitId, progress.date);
    await _box.put(key, progress);
  }

  /// Get all progress entries for a habit (sorted by date)
  List<DailyProgress> getAllForHabit(String habitId) {
    return _box.values
        .where((p) => p.habitId == habitId)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Calculate habit streaks
  HabitProgress calculateHabitProgress(String habitId, List<int> scheduleWeekdays) {
    final allProgress = getAllForHabit(habitId);

    int currentStreak = 0;
    int bestStreak = 0;
    int completionCount = 0;

    DateTime? lastCompletedDate;

    for (final progress in allProgress) {
      final date = DateTime(progress.date.year, progress.date.month, progress.date.day);

      // Skip future days
      if (date.isAfter(getTodayDate())) continue;

      // Skip non-scheduled days
      if (!scheduleWeekdays.contains(date.weekday)) continue;

      if (progress.isCompleted) {
        completionCount++;

        // Streak calculation
        if (lastCompletedDate == null ||
            date.difference(lastCompletedDate).inDays ==
                getNextScheduledDayGap(lastCompletedDate, scheduleWeekdays)) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }

        bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
        lastCompletedDate = date;
      } else {
        currentStreak = 0;
        lastCompletedDate = null;
      }
    }

    return HabitProgress(
      habitId: habitId,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      completionCount: completionCount,
    );
  }

  /// Helper: calculate gap to next scheduled day
  int getNextScheduledDayGap(DateTime prev, List<int> scheduleWeekdays) {
    final sorted = [...scheduleWeekdays]..sort();
    int prevWeekday = prev.weekday;

    for (final day in sorted) {
      if (day > prevWeekday) return day - prevWeekday;
    }
    return 7 - prevWeekday + sorted.first; // wrap to next week
  }

  /// Helper: consistent key for Hive
  String _key(String habitId, DateTime date) {
    final d =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${habitId}_$d';
  }
}

