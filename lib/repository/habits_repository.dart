import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/habit.dart';

class HabitRepository {
  Future<List<Habit>> loadHabits() async {
    final String jsonStr = await rootBundle.loadString('assets/data/habits.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Habit.fromJson(e)).toList();
  }
}