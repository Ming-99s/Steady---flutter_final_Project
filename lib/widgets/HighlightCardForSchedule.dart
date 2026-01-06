import 'package:flutter/material.dart';
import 'package:steady/models/habit.dart';
import '../theme/appColor.dart';
import '../utils/helper.dart';

class HighlightSchedulecard extends StatelessWidget {
  const HighlightSchedulecard({
    super.key,
    required this.habit,
    required this.icon,
    required this.title,
    required this.schedule,
  });

  final Habit habit;
  final IconData icon;
  final String title;
  final List<int> schedule;

  @override
  Widget build(BuildContext context) {
    String resultSchedule = scheduleForCard(schedule);

    // Reusable day button
    Widget _buildDayButtonInt(int day, BuildContext context, List<int> activeDays) {
      final isSelected = activeDays.contains(day);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppColors.getPrimary(context)
                : AppColors.getBackground(context),
          ),
          child: Text(
            dayAbbrInt(day),
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.secondary)
                  : AppColors.getTextPrimary(context),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          // Show bottom sheet with all days
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Schedule',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        7,
                        (index) => _buildDayButtonInt(index , context, schedule),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
        child: 
          // Expanded(
            // child: 
            Container(
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
                      const SizedBox(height: 40),
                      Text(
                        resultSchedule,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.getTextPrimary(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(fontSize: 15),
                      ),
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
                        child: Icon(
                          icon,
                          color: AppColors.darkPrimary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          // ),
        
      ),
    );
  }
}
