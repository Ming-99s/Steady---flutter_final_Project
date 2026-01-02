import 'package:flutter/material.dart';
import 'package:steady/theme/appColor.dart';
import 'package:steady/models/dialyProgress.dart';

class Trackerscreen extends StatefulWidget {
  const Trackerscreen({super.key});

  @override
  State<Trackerscreen> createState() => _TrackerscreenState();
}

class _TrackerscreenState extends State<Trackerscreen> {
  @override
  Widget build(BuildContext context) {
    // Sample data - generates 147 days of data with randomized completion
    final sampleDailyProgress1 = List.generate(147, (index) {
      // Randomly mark some days as completed for more realistic sample data
      final isCompleted = (index % 3 == 0) || (index >= 145); // 1/3 of days + last 2
      return DailyProgress(
        habitId: 1,
        date: DateTime.now().subtract(Duration(days: 146 - index)),
        isCompleted: isCompleted,
      );
    });

    final sampleDailyProgress2 = List.generate(147, (index) {
      // Different pattern for second habit
      final isCompleted = (index % 4 == 0) || (index == 146); // 1/4 of days + last day
      return DailyProgress(
        habitId: 2,
        date: DateTime.now().subtract(Duration(days: 146 - index)),
        isCompleted: isCompleted,
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Habits title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Habits',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Habits list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  HabitCard(
                    icon: Icons.water_drop_outlined,
                    iconColor: AppColors.textSecondary,
                    title: 'No Gooning',
                    description: 'No Gooning',
                    dailyProgress: sampleDailyProgress1,
                  ),
                  const SizedBox(height: 16),
                  HabitCard(
                    icon: Icons.tag,
                    iconColor: AppColors.textSecondary,
                    title: 'Jogging',
                    description: 'Description',
                    dailyProgress: sampleDailyProgress2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<DailyProgress> dailyProgress;

  const HabitCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.dailyProgress,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  void _toggleTodayCompletion() {
    setState(() {
      // Get today's daily progress (last item)
      if (widget.dailyProgress.isNotEmpty) {
        widget.dailyProgress.last.isCompleted =
            !widget.dailyProgress.last.isCompleted;
      }
    });
  }

  void _toggleDateCompletion(int index) {
    setState(() {
      widget.dailyProgress[index].isCompleted =
          !widget.dailyProgress[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate completion count from dailyProgress
    final completionCount = widget.dailyProgress
        .where((day) => day.isCompleted)
        .length;

    // Check if today is completed (last item in the list)
    final isTodayCompleted =
        widget.dailyProgress.isNotEmpty && widget.dailyProgress.last.isCompleted;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with icon, title, and checkmark
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: TextStyle(color: AppColors.offNav, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Checkmark button with completion count - NOW INTERACTIVE
              GestureDetector(
                onTap: _toggleTodayCompletion,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isTodayCompleted
                            ? AppColors.textSecondary
                            : AppColors.border,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ),
                    if (completionCount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$completionCount',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress grid - Interactive and date-based
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 21, // 3 weeks (21 days per row)
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: widget.dailyProgress.length,
            itemBuilder: (context, index) {
              final dayData = widget.dailyProgress[index];
              final today = DateTime.now();
              final isCurrentDay = dayData.date.year == today.year &&
                  dayData.date.month == today.month &&
                  dayData.date.day == today.day;

              return GestureDetector(
                onTap: () => _toggleDateCompletion(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: dayData.isCompleted
                        ? AppColors.textSecondary
                        : AppColors.border,
                    shape: BoxShape.circle,
                    border: isCurrentDay
                        ? Border.all(
                            color: AppColors.textPrimary,
                            width: 2,
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
