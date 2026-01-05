import 'package:flutter/material.dart';
import '../../models/habit.dart';
import '../../widgets/habitProgress.dart';
import '../../theme/appColor.dart';

class Trackerscreen extends StatelessWidget {
  final List<Habit> habits;

  const Trackerscreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.getSecondary(context), // background like appbar
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(13, 73, 72, 72),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5), // shadow downwards
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tracker',
                          style: TextStyle(
                            color: AppColors.getTextPrimary(context),
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,

              color: AppColors.getBackground(context),
              child: habits.isEmpty
                  ? Center(
                      child: Text(
                        "No habits yet",
                        style: TextStyle(
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: habits.map((habit) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: HabitProgress(habit: habit),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
