import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steady/utils/iconData.dart';
import '../models/habit.dart';
import '../repository/repoDialyGlobal.dart';
import '../theme/appColor.dart';

class HabitProgress extends StatefulWidget {
  final Habit habit;
  const HabitProgress({super.key, required this.habit});

  @override
  State<HabitProgress> createState() => _HabitProgressState();
}

class _HabitProgressState extends State<HabitProgress> {
  final repo = dailyProgressRepo;
  final Map<DateTime, int> _progressMap = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProgress();
    repo.addListener(_loadProgress);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    repo.removeListener(_loadProgress);
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
    const double cellWidth = 16 + 6; // cell + spacing
    DateTime today = DateTime.now();
    DateTime startDate = today.subtract(const Duration(days: 365));
    DateTime firstMonday = startDate.subtract(Duration(days: startDate.weekday - 1));
    int weekIndex = ((today.difference(firstMonday).inDays) / 7).floor();
    double offset = weekIndex * cellWidth;
    if (_scrollController.hasClients) _scrollController.jumpTo(offset);
  }

  Color _cellColor(DateTime date) {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    if (date.isAfter(todayKey)) return Colors.transparent;

    final habitStart = DateTime(widget.habit.startDate.year,
        widget.habit.startDate.month, widget.habit.startDate.day);
    if (date.isBefore(habitStart)) return AppColors.border;

    final completed = _progressMap[date] ?? 0;

    if (completed == 0) return AppColors.border;
    if (completed < widget.habit.timePerDay / 2) return const Color(0xFF90CAF9);

    return AppColors.textSecondary;
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
    DateTime firstMonday = startDate.subtract(Duration(days: startDate.weekday - 1));

    const int weekCount = 54;
    final List<List<DateTime>> weeks = [];
    DateTime cursor = firstMonday;

    for (int i = 0; i < weekCount; i++) {
      final week = List.generate(7, (d) => cursor.add(Duration(days: d)));
      weeks.add(week);
      cursor = cursor.add(const Duration(days: 7));
    }

    // Month labels
    final List<Widget> monthLabels = [];
    String? lastMonth;
    for (final week in weeks) {
      final firstDayOfWeek = week.first;
      final monthName = DateFormat.MMM().format(firstDayOfWeek);
      if (monthName != lastMonth && firstDayOfWeek.day <= 7) {
        monthLabels.add(SizedBox(
          width: 22,
          child: Text(
            monthName,
            style: const TextStyle(fontSize: 10, color: AppColors.offNav),
          ),
        ));
        lastMonth = monthName;
      } else {
        monthLabels.add(const SizedBox(width: 22));
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habit.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.habit.description?.isNotEmpty == true)
                            Text(
                              widget.habit.description!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.offNav,
                              ),
                            ),
                        ],
                      ),
                    ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isCompleted(todayKey) ? AppColors.darkPrimary : AppColors.border
                        ),
                        child:  _isCompleted(todayKey) ? Icon(Icons.check,
                            color: AppColors.secondary, size: 20) : Icon(Icons.task,
                            color: AppColors.secondary, size: 20),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // HEATMAP
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels (Mon-Sun)
              Column(
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map(
                      (day) => SizedBox(
                        height: 16,
                        width: 16,
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.offNav,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(width: 10),

              // Scrollable heatmap
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                final isToday = normalizedDate == todayKey;

                                return Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _cellColor(normalizedDate),
                                    borderRadius: BorderRadius.circular(4),
                                    border: isToday
                                        ? Border.all(
                                            color: AppColors.textPrimary,
                                            width: 1.5,
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),

                      // Month labels below
                      Row(children: monthLabels),
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
