
enum Day {
  monday("Mon"),
  tuesday("Tue"),
  wednesday("Wed"),
  thursday("Thu"),
  friday("Fri"),
  saturday("Sat"),
  sunday("Sun");

  final String label;

  const Day(this.label);
}

enum Schedule { everyday, weekend, specificDay }

enum MoodType {
  motivate(image: 'motivate.png', title: 'Motivation'),
  normal(image: 'okay.png', title: 'Okay'),
  stressed(image: 'stressed.png', title: 'Stressed'),
  tired(image: 'tired.png', title: 'Tired');

  final String image;
  final String title;

  const MoodType({required this.image, required this.title});
}

enum AllTab { home, add, tracker, setting }

enum HighlightType {
  currentStreak,
  bestStreak,
  completionCount,
}

final List<String> daysOfWeek = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];
