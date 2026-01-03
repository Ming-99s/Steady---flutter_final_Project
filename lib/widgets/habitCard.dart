import 'package:flutter/material.dart';
import 'package:steady/utils/iconData.dart';
import '../models/habit.dart';
import '../theme/appColor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';

class HabitCircleWidget extends StatefulWidget {
  final Habit habit;
  const HabitCircleWidget({super.key, required this.habit});

  @override
  State<HabitCircleWidget> createState() => _HabitCircleWidgetState();
}

class _HabitCircleWidgetState extends State<HabitCircleWidget> {
  double size = 130;
  int currentStep = 0; 
  double progress = 0.0; 
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startHold() {
    // only allow next step if not finished all steps
    if (currentStep >= widget.habit.timePerDay) return;
    if (_timer != null && _timer!.isActive) return;

    const stepDuration = Duration(milliseconds: 16);
    double increment = 16 / 1000; // 16ms / 1000ms = fraction per tick (~1s total)

    _timer = Timer.periodic(stepDuration, (_) {
      setState(() {
        progress += increment;

        
        if (progress >= 1.0) {
          progress = 0.0;
          currentStep++;
          _timer?.cancel(); 
        }
      });
    });
  }

  void _stopHold() {
    _timer?.cancel();
    setState(() {
      progress = 0.0; 
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxSteps = widget.habit.timePerDay;
    double totalProgress =
        (currentStep / maxSteps) + (progress / maxSteps);

    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => _startHold(),
          onLongPressEnd: (_) => _stopHold(),
          child: CircularPercentIndicator(
            radius: size / 2,
            lineWidth: 8,
            percent: totalProgress.clamp(0.0, 1.0),
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
                SizedBox(height: 4),
                Text(
                  "$currentStep/$maxSteps",
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.habit.title ?? "Habit",
          style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
