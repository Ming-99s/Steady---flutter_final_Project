import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steady/utils/iconData.dart';
import '../models/habit.dart';
import '../repository/repoDialyGlobal.dart';
import '../theme/appColor.dart';

class Habitprogress extends StatefulWidget {
  final Habit habit;

  const Habitprogress({super.key, required this.habit});

  @override
  State<Habitprogress> createState() => _HabitprogressState();
}

class _HabitprogressState extends State<Habitprogress> {
  final repo = dailyProgressRepo;
  Map<DateTime, int> _progressMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgress();
      repo.addListener(_loadProgress);
    });
  }

  @override
  void dispose() {
    repo.removeListener(_loadProgress);
    super.dispose();
  }

  void _loadProgress() {
    final all = repo.getAllForHabit(widget.habit.habitId);
    final map = <DateTime, int>{};

    for (var p in all) {
      final d = DateTime(p.date.year, p.date.month, p.date.day);
      map[d] = p.completedUnits;
    }

    if (!mounted) return;
    setState(() => _progressMap = map);
  }

  Color _getCellColor(int completed) {
    final target = widget.habit.timePerDay;
    if (completed == 0 || target <= 0) return AppColors.border;

    final ratio = completed / target;
    return AppColors.textSecondary.withOpacity(ratio.clamp(0.2, 0.9));
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final startDate = DateTime(
      widget.habit.startDate.year,
      widget.habit.startDate.month,
      widget.habit.startDate.day,
    );

    // If habit started today or in future, show just today
    if (startDate.isAfter(todayNormalized)) {
      // You can return a simple "Not started yet" message or empty grid
      return const SizedBox.shrink();
    }

    // Find Monday of the week containing startDate
    final int startWeekday = startDate.weekday; // 1=Monday, 7=Sunday
    final DateTime firstMonday = startDate.subtract(Duration(days: startWeekday - 1));

    // Generate weeks: oldest → newest
    final List<List<DateTime?>> weeks = [];
    DateTime currentMonday = firstMonday;

    while (true) {
      final week = List<DateTime?>.generate(7, (i) {
        final day = currentMonday.add(Duration(days: i));
        // Include only days from startDate to today (inclusive)
        if (day.isBefore(startDate) || day.isAfter(todayNormalized)) {
          return null;
        }
        return day;
      });

      // Add week only if it has at least one valid day
      if (week.any((d) => d != null)) {
        weeks.add(week);
      } else {
        break; // No more days to show
      }

      currentMonday = currentMonday.add(const Duration(days: 7));
    }

    // Stats
    final int completionCount = _progressMap.values
        .where((v) => v >= widget.habit.timePerDay)
        .length;

    final bool isTodayCompleted =
        (_progressMap[todayNormalized] ?? 0) >= widget.habit.timePerDay;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconMap[widget.habit.iconName] ?? Icons.help_outline,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habit.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.habit.description?.isNotEmpty == true)
                      Text(
                        widget.habit.description!,
                        style: const TextStyle(color: AppColors.offNav, fontSize: 14),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isTodayCompleted ? AppColors.textSecondary : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isTodayCompleted ? Icons.check : Icons.priority_high,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (completionCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '$completionCount total',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Heatmap Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels: Mon to Sun
              Column(
                children: List.generate(7, (i) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return SizedBox(
                    height: 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        days[i],
                        style: const TextStyle(fontSize: 10, color: AppColors.offNav),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),

              // Scrollable heatmap + month labels
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // Today on the far right
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grid cells
                      Row(
                        children: weeks.map((week) {
                          return SizedBox(
                            width: 20,
                            child: Column(
                              children: List.generate(7, (dayIndex) {
                                final date = week[dayIndex];
                                final completed = date != null ? (_progressMap[date] ?? 0) : 0;
                                final isToday = date != null && date.isAtSameMomentAs(todayNormalized);

                                return Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: date == null ? Colors.transparent : _getCellColor(completed),
                                    borderRadius: BorderRadius.circular(4),
                                    border: isToday
                                        ? Border.all(color: AppColors.textPrimary, width: 1.5)
                                        : null,
                                  ),
                                );
                              }),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),

                      // Month labels - perfectly aligned and centered
                      Row(
                        children: weeks.map((week) {
                          final firstDay = week.firstWhere(
                            (d) => d != null,
                            orElse: () => null,
                          );
                          if (firstDay == null) return const SizedBox(width: 20);

                          final weekIndex = weeks.indexOf(week);
                          String? label;

                          if (weekIndex == 0) {
                            label = DateFormat.MMM().format(firstDay);
                          } else {
                            final prevFirst = weeks[weekIndex - 1].firstWhere(
                              (d) => d != null,
                              orElse: () => null,
                            );
                            if (prevFirst != null && firstDay.month != prevFirst.month) {
                              label = DateFormat.MMM().format(firstDay);
                            }
                          }

                          return SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: label != null
                                  ? Text(
                                      label,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.offNav,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}