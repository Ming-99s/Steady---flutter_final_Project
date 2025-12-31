class DailyProgress {
  final int habitId;
  final DateTime date;
  int completedUnits;
  bool isCompleted;
  bool isPaused;

  DailyProgress({
    required this.habitId,
    required this.date,
    this.completedUnits = 0,
    this.isCompleted = false,
    this.isPaused = false,
  });
}