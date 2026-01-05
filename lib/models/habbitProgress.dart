class HabitProgress {
  final String habitId;
  int currentStreak;
  int bestStreak;
  int completionCount;

  HabitProgress({
    required this.habitId,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completionCount = 0,
  });
}
