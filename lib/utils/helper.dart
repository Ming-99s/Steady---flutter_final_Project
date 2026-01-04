import 'enums.dart';

String scheduleLabel(Schedule s) {
  switch (s) {
    case Schedule.everyday:
      return 'Every Day';
    case Schedule.weekend:
      return 'Weekend';
    case Schedule.specificDay:
      return 'Specific Day';
  }
}

Schedule getScheduleType(List<Day> schedule) {
  final allDays = Day.values.toSet();
  final weekendDays = {Day.saturday, Day.sunday};

  final scheduleSet = schedule.toSet();

  if (scheduleSet.containsAll(allDays) && scheduleSet.length == 7) {
    return Schedule.everyday;
  }

  if (scheduleSet.containsAll(weekendDays) && scheduleSet.length == 2) {
    return Schedule.weekend;
  }

  return Schedule.specificDay;
}


String dayAbbr(Day day) {
  switch(day) {
    case Day.monday: return 'Mon';
    case Day.tuesday: return 'Tue';
    case Day.wednesday: return 'Wed';
    case Day.thursday: return 'Thu';
    case Day.friday: return 'Fri';
    case Day.saturday: return 'Sat';
    case Day.sunday: return 'Sun';
  }
}
