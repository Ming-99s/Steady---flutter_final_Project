import 'package:flutter/material.dart';
import '../utils/enums.dart';

class Habbit{
  final String habbitId;
  final String title;
  final String? description;
  final int timePerDay;
  final IconData icon;
  final List<Day> schedule;

  Habbit({required this.habbitId,required this.title,this.description,required this.timePerDay,required this.icon,required this.schedule});
}