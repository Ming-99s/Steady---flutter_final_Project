import 'package:hive/hive.dart';

part 'dialyProgress.g.dart';

@HiveType(typeId: 1)
class DailyProgress extends HiveObject {
  @HiveField(0)
  final String habitId;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  int completedUnits;

  @HiveField(3)
  bool isCompleted;



  DailyProgress({
    required this.habitId,
    required this.date,
    this.completedUnits = 0,
    this.isCompleted = false,
  });
}
