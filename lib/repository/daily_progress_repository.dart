import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/dialyProgress.dart';

class DailyProgressRepository extends ChangeNotifier {
  static const String _boxName = 'daily_progress';

  Box<DailyProgress> get _box => Hive.box<DailyProgress>(_boxName);

  DailyProgress getToday(String habitId) {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);
    final key = _key(habitId, dateOnly);

    return _box.get(
      key,
      defaultValue: DailyProgress(habitId: habitId, date: dateOnly),
    )!;
  }

  Future<void> upsert(DailyProgress progress) async {
    final key = _key(progress.habitId, progress.date);
    await _box.put(key, progress);

    if (!hasListeners) return;
    notifyListeners();
  }

  List<DailyProgress> getAllForHabit(String habitId) {
    return _box.values.where((p) => p.habitId == habitId).toList();
  }

  String _key(String habitId, DateTime date) {
    final d =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${habitId}_$d';
  }
}
