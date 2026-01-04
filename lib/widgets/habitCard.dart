import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/habit.dart';
import '../models/dialyProgress.dart';
import '../theme/appColor.dart';
import '../utils/iconData.dart';
import '../repository/repoDialyGlobal.dart';

class HabitCircleWidget extends StatefulWidget {
  final Habit habit;
  const HabitCircleWidget({super.key, required this.habit});

  @override
  State<HabitCircleWidget> createState() => _HabitCircleWidgetState();
}

class _HabitCircleWidgetState extends State<HabitCircleWidget> {
  final repo = dailyProgressRepo;

  double size = 130;
  int currentStep = 0;
  double holdProgress = 0.0;
  DailyProgress? dailyProgress;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    repo.addListener(_loadProgress); // listen for repo changes
  }

  @override
  void dispose() {
    _timer?.cancel();
    repo.removeListener(_loadProgress);
    super.dispose();
  }

  Future<void> _loadProgress() async {
    DateTime today = DateTime.now();
    dailyProgress = repo.getToday(widget.habit.habitId);

    // Create daily progress if missing
    if (dailyProgress == null) {
      dailyProgress = DailyProgress(
        habitId: widget.habit.habitId,
        date: today,
      );
      await repo.upsert(dailyProgress!);
    }

    setState(() {
      currentStep = dailyProgress!.completedUnits;
    });
  }

  void _startHold() {
    if (currentStep >= widget.habit.timePerDay) return;
    if (_timer?.isActive == true) return;

    const tick = Duration(milliseconds: 16);
    const holdSeconds = 1.0;
    final increment = tick.inMilliseconds / (holdSeconds * 1000);

    _timer = Timer.periodic(tick, (_) {
      setState(() {
        holdProgress += increment;

        if (holdProgress >= 1.0) {
          holdProgress = 0.0;
          currentStep++;
          if (currentStep > widget.habit.timePerDay) {
            currentStep = widget.habit.timePerDay;
          }
          _onStepCompleted();
          _timer?.cancel(); // stop after completing 1 unit
        }
      });
    });
  }

  void _stopHold() {
    // Just cancel timer and reset hold progress; do NOT increment step
    _timer?.cancel();
    setState(() => holdProgress = 0.0);
  }

  Future<void> _onStepCompleted() async {
    if (dailyProgress == null) return;

    dailyProgress!
      ..completedUnits = currentStep
      ..isCompleted = currentStep >= widget.habit.timePerDay;

    await repo.upsert(dailyProgress!);
  }

  @override
  Widget build(BuildContext context) {
    int maxSteps = widget.habit.timePerDay;
    double totalProgress =
        ((currentStep + holdProgress) / maxSteps).clamp(0.0, 1.0);

    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => _startHold(),
          onLongPressEnd: (_) => _stopHold(),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: CircularPercentIndicator(
              radius: size / 2,
              lineWidth: 8,
              percent: totalProgress,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: AppColors.offNav,
              progressColor: AppColors.primary,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconMap[widget.habit.iconName] ?? Icons.help,
                    size: 50,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$currentStep/$maxSteps",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.habit.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
