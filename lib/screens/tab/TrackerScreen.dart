import 'package:flutter/material.dart';
import '../../widgets/habit_heatmap.dart';
import '../../models/habit.dart';

class Trackerscreen extends StatelessWidget {
  final List<Habit> habits; // multiple habits

  const Trackerscreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: habits.map((habit) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HabitHeatmap(habit: habit), // your heatmap widget
                ),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
