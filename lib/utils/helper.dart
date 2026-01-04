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
