import 'package:flutter/material.dart';
import 'package:steady/utils/iconData.dart';
import '../models/habit.dart';
import '../repository/repoDialyGlobal.dart';
import '../theme/appColor.dart';
import '../screens/habitDetail.dart';
import '../utils/helper.dart';

class HabitProgress extends StatefulWidget {
  final Habit habit;
  final Function() onRefresh;
  const HabitProgress({
    super.key,
    required this.habit,
    required this.onRefresh,
  });

  @override
  State<HabitProgress> createState() => HabitProgressState();
}

class HabitProgressState extends State<HabitProgress> {
  final repo = dailyProgressRepo;
  final Map<DateTime, int> _progressMap = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProgress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void didUpdateWidget(covariant HabitProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadProgress();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadProgress() {
    final all = repo.getAllForHabit(widget.habit.habitId);
    _progressMap.clear();
    for (final p in all) {
      final key = DateTime(p.date.year, p.date.month, p.date.day);
      _progressMap[key] = p.completedUnits;
    }
    if (mounted) setState(() {});
  }

  void _scrollToToday() {
    const double cellWidth = 22; // cell + spacing
    DateTime today = DateTime.now();
    DateTime startDate = today.subtract(const Duration(days: 365));
    DateTime firstMonday = startDate.subtract(
      Duration(days: startDate.weekday - 1),
    );
    int weekIndex = ((today.difference(firstMonday).inDays) / 7).floor();
    double offset = weekIndex * cellWidth;
    if (_scrollController.hasClients) _scrollController.jumpTo(offset);
  }

  bool _isCompleted(DateTime date) {
    final completed = _progressMap[date] ?? 0;
    return completed >= widget.habit.timePerDay;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    DateTime startDate = today.subtract(const Duration(days: 365));
    DateTime firstMonday = startDate.subtract(
      Duration(days: startDate.weekday - 1),
    );

    const int weekCount = 54;
    final List<List<DateTime>> weeks = [];
    DateTime cursor = firstMonday;
    for (int i = 0; i < weekCount; i++) {
      final week = List.generate(7, (d) => cursor.add(Duration(days: d)));
      weeks.add(week);
      cursor = cursor.add(const Duration(days: 7));
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HabitDetailScreen(
              habit: widget.habit,
              onRefresh: widget.onRefresh,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.getSecondary(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.getBorder(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER: icon, title, tick if today completed
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
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.habit.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isCompleted(todayKey)
                              ? AppColors.darkPrimary
                              : AppColors.border,
                        ),
                        child: _isCompleted(todayKey)
                            ? const Icon(
                                Icons.check,
                                color: AppColors.secondary,
                                size: 20,
                              )
                            : const Icon(
                                Icons.task,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // HEATMAP GRID ONLY
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: weeks.map((week) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Column(
                      children: week.map((date) {
                        final normalizedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                        return Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: cellColor(
                              normalizedDate,
                              widget.habit,
                              _progressMap,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
