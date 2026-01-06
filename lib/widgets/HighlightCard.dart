import 'package:flutter/material.dart';
import 'package:steady/models/habit.dart';
import '../theme/appColor.dart';
import '../repository/repoDialyGlobal.dart';
import '../utils/enums.dart';

class Highlightcard extends StatelessWidget {
  const Highlightcard({
    super.key,
    required this.habit,
    required this.type,
    required this.icon,
    required this.title,
  });

  final Habit habit;
  final HighlightType type;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: dailyProgressRepo, 
      builder: (context, _) {
        final habitProgress =
            dailyProgressRepo.calculateHabitProgress(
          habit.habitId,
          habit.scheduleIndices,
        );

        int value;
        switch (type) {
          case HighlightType.currentStreak:
            value = habitProgress.currentStreak;
            break;
          case HighlightType.bestStreak:
            value = habitProgress.bestStreak;
            break;
          case HighlightType.completionCount:
            value = habitProgress.completionCount;
            break;
        }

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.getSecondary(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    '$value',
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColors.getTextPrimary(context),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(title, style: const TextStyle(fontSize: 15)),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(icon, color: AppColors.darkPrimary, size: 30),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
