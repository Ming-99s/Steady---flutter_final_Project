import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../repository/repoDialyGlobal.dart';

class HabitHeatmap extends StatefulWidget {
  final Habit habit;
  const HabitHeatmap({super.key, required this.habit});

  @override
  State<HabitHeatmap> createState() => _HabitHeatmapState();
}

class _HabitHeatmapState extends State<HabitHeatmap> {
  final repo = dailyProgressRepo;
  Map<DateTime, int> _progressMap = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
    repo.addListener(_loadProgress); // 👂 listen
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

    setState(() {
      _progressMap = map;
    });
  }

  Color _getColor(int completed, int max) {
    if (completed == 0) return Colors.grey[200]!;
    double ratio = completed / max;
    if (ratio <= 0.25) return Colors.green[100]!;
    if (ratio <= 0.5) return Colors.green[300]!;
    if (ratio <= 0.75) return Colors.green[500]!;
    return Colors.green[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, today.day).subtract(const Duration(days: 364));

    // Determine how many columns per row to fit the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = 12.0; // small enough to fit multiple rows
    final spacing = 2.0;
    final cellsPerRow = (screenWidth / (cellSize + spacing)).floor();

    List<Widget> rows = [];
    List<Widget> currentRow = [];
    DateTime currentDate = startDate;

    for (int i = 0; i < 365; i++) {
      final normalized = DateTime(currentDate.year, currentDate.month, currentDate.day);
      int completed = _progressMap[normalized] ?? 0;

      currentRow.add(Container(
        width: cellSize,
        height: cellSize,
        margin: EdgeInsets.all(spacing / 2),
        decoration: BoxDecoration(
          color: _getColor(completed, widget.habit.timePerDay),
          borderRadius: BorderRadius.circular(2),
        ),
      ));

      if (currentRow.length >= cellsPerRow) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currentRow,
        ));
        currentRow = [];
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Add any leftover cells
    if (currentRow.isNotEmpty) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: currentRow,
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}
