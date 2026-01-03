import 'package:flutter/material.dart';
import '../utils/enums.dart';

class Habit {
  final String habitId;
  final String title;
  final String? description;
  final int timePerDay;
  final String iconName;
  final List<Day> schedule;
  final DateTime startDate;

  Habit({
    required this.habitId,
    required this.title,
    this.description,
    required this.timePerDay,
    required this.iconName,
    required this.schedule,
    required this.startDate,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      habitId: json['habitId'],
      title: json['title'],
      description: json['description'],
      timePerDay: json['timePerDay'],
      iconName: json['iconName'],
      schedule: (json['schedule'] as List).map((i) => Day.values[i]).toList(),
      startDate: DateTime.parse(json['startDate']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'title': title,
      'description': description,
      'timePerDay': timePerDay,
      'iconName': iconName,
      'schedule': schedule.map((d) => d.index).toList(),
      'startDate': startDate.toIso8601String(),
    };
  }
}
