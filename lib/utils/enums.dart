import 'dart:ui';

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

enum TrackTheme {
  red(color: Color(0xFFFF6B6B)),
  blue(color: Color(0xFF3B82F6)),
  yellow(color: Color(0xFFFFE66D)),
  green(color: Color(0xFF95E1D3)),
  purple(color: Color(0xFFC7CEEA)),
  orange(color: Color(0xFFFF9FF3)),
  pink(color: Color(0xFFF8B195)),
  teal(color: Color(0xFF55A3FF)),
  indigo(color: Color(0xFF6C5CE7)),
  cyan(color: Color(0xFF00CEC9)),
  lime(color: Color(0xFFA4DE6C)),
  coral(color: Color(0xFFFF7675)),
  magenta(color: Color(0xFFFD79A8)),
  turquoise(color: Color(0xFF74B9FF)),
  lavender(color: Color(0xFFDFE6E9));

  final Color color;

  const TrackTheme({required this.color});
}
