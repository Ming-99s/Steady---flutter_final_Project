class PausedDays {
  DateTime weekStartDate;
  int remainingPauses; 

  PausedDays({
    required this.weekStartDate,
    this.remainingPauses = 5,
  });
}