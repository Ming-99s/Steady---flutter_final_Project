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

String scheduleForCard(List<int> days) {
  if (days.isEmpty) return 'No schedule';

  final sorted = [...days]..sort();

  // Everyday: 1–7
  if (sorted.length == 7 &&
      sorted.first == 0 &&
      sorted.last == 6) {
    return 'Everyday';
  }

  // Weekend: Saturday + Sunday
  if (sorted.length == 2 &&
      sorted.contains(5) &&
      sorted.contains(6)) {
    return 'Weekend';
  }

  // Otherwise: specific days
  return 'Specific day';
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

String dayAbbrInt(int day) {
  switch(day) {
    case 0: return 'Mon';
    case 1: return 'Tue';
    case 2: return 'Wed';
    case 3: return 'Thu';
    case 4: return 'Fri';
    case 5: return 'Sat';
    case 6: return 'Sun';
    default : return '';
  }
}
