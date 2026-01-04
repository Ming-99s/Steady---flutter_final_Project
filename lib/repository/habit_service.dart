import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../utils/enums.dart';

class HabitRepository extends ChangeNotifier {
  static const String _boxName = 'habits';
  static const Uuid _uuid = Uuid();

  Box<Habit> get _box => Hive.box<Habit>(_boxName);

  Future<Habit> createHabit({
    required String title,
    String? description,
    required int timePerDay,
    required String iconName,
    required List<Day> schedule,
    required DateTime startDate,
  }) async {
    final habit = Habit.create(
      habitId: _uuid.v4(),
      title: title,
      description: description,
      timePerDay: timePerDay,
      iconName: iconName,
      schedule: schedule,
      startDate: startDate,
    );

    await _box.put(habit.habitId, habit);
    notifyListeners();
    return habit;
  }

  List<Habit> getAllHabits() => _box.values.toList();

  Future<void> updateHabit(Habit habit) async {
    await _box.put(habit.habitId, habit);
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    await _box.delete(habitId);
    notifyListeners();
  }

  Habit? getHabit(String habitId) => _box.get(habitId);
}
