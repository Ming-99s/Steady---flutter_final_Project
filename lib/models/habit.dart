import 'package:flutter/material.dart';
import '../utils/enums.dart';

class Habit{
  final String habbitId;
  final String title;
  final String? description;
  final int timePerDay;
  final IconData icon;
  final List<Day> schedule;
  final DateTime startDate;


  Habit({required this.habbitId,required this.title,this.description,required this.timePerDay,required this.icon,required this.schedule,required this.startDate});
}