import 'package:flutter/material.dart';
import 'package:steady/utils/iconData.dart';
import '../models/habit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../theme/appColor.dart';


class HabitCircleWidget extends StatefulWidget {
  final Habit habit;
  const HabitCircleWidget({super.key, required this.habit});

  @override
  State<HabitCircleWidget> createState() => _HabitCircleWidgetState();
}

class _HabitCircleWidgetState extends State<HabitCircleWidget> with SingleTickerProviderStateMixin {
  double size = 130;
  int currentStep = 0; 
  late AnimationController _controller;
  double progress = 0.0; 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), 
    )..addListener(() {
        setState(() {
          progress = _controller.value;
        });
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {

        _controller.reset();
        setState(() {
          currentStep++;
          progress = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (currentStep < widget.habit.timePerDay) {
      _controller.forward(from: 0);
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_controller.isAnimating) {
      _controller.stop();
      _controller.reset();
      setState(() {
        progress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalProgress = (currentStep / widget.habit.timePerDay) + (progress / widget.habit.timePerDay);

    return Column(
      children: [
        GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Container(
                width: size+10,
                height: size+10,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.offNav, width: 8),
                ),
              ),

              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: totalProgress.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  color: AppColors.primary,
                  backgroundColor: Colors.transparent,
                ),
              ),
             
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconMap[widget.habit.iconName],
                    size: 50,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$currentStep/${widget.habit.timePerDay}",
                    style: TextStyle(color: AppColors.textPrimary,fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.habit.title,
          style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
