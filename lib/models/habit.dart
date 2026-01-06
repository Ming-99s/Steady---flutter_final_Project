// models/habit.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/enums.dart';

part 'habit.g.dart';

@HiveType(typeId : 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String habitId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final int timePerDay;

  @HiveField(4)
  final String iconName;

  @HiveField(5)
  List<int> scheduleIndices;

  @HiveField(6)
  final DateTime startDate;

  // Regular constructor for Hive (all fields required)
  Habit({
    required this.habitId,
    required this.title,
    this.description,
    required this.timePerDay,
    required this.iconName,
    required this.scheduleIndices,
    required this.startDate,
  });

  // Factory for easy creation (with List<Day> and auto UUID)
  factory Habit.create({
    String? habitId,
    required String title,
    String? description,
    required int timePerDay,
    required String iconName,
    required List<Day> schedule,
    required DateTime startDate,
  }) {
    return Habit(
      habitId: habitId ?? const Uuid().v4(),
      title: title,
      description: description,
      timePerDay: timePerDay,
      iconName: iconName,
      scheduleIndices: schedule.map((day) => day.index).toList(),
      startDate: startDate,
    );
  }

  // Helper to get real schedule
  List<Day> get schedule => scheduleIndices.map((i) => Day.values[i]).toList();
}