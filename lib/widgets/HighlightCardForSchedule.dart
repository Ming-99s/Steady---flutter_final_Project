import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steady/models/habit.dart';
import '../theme/appColor.dart';
import '../utils/helper.dart';
import '../repository/habitGlobal.dart';

class HighlightSchedulecard extends StatefulWidget {
  const HighlightSchedulecard({
    super.key,
    required this.habit,
    required this.icon,
    required this.title,
  });

  final Habit habit;
  final IconData icon;
  final String title;

  @override
  State<HighlightSchedulecard> createState() => _HighlightSchedulecardState();
}

class _HighlightSchedulecardState extends State<HighlightSchedulecard> {
  late Habit _habit;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit; // local habit copy

    // Listen to habitRepo for updates
    habitRepo.addListener(_loadHabit);
  }

  @override
  void dispose() {
    habitRepo.removeListener(_loadHabit);
    super.dispose();
  }

  void _loadHabit() {
    final updatedHabit = habitRepo.getHabit(_habit.habitId);
    if (updatedHabit != null &&
        mounted &&
        !listEquals(_habit.scheduleIndices, updatedHabit.scheduleIndices)) {
      setState(() {
        _habit = updatedHabit;
      });
    }
  }

  void _updateSchedule(List<int> newSchedule) {
    setState(() {
      _habit.scheduleIndices = List.from(newSchedule); // update local habit
    });
    habitRepo.updateHabit(_habit); // notify repo if needed
  }

  Widget _buildDayButtonInt(int day, BuildContext context, List<int> activeDays) {
    final isSelected = activeDays.contains(day);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    String resultSchedule = scheduleForCard(_habit.scheduleIndices);

    return Expanded(
      child: GestureDetector(
        onLongPress: () async {
          // Show bottom sheet with all days
          final updatedSchedule = await showModalBottomSheet<List<int>>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) {
              List<int> tempSchedule = List.from(_habit.scheduleIndices);
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
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (tempSchedule.contains(index)) {
                                tempSchedule.remove(index);
                              } else {
                                tempSchedule.add(index);
                              }
                            });
                          },
                          child: _buildDayButtonInt(index, context, tempSchedule),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            },
          );
      
          if (updatedSchedule != null) {
            _updateSchedule(updatedSchedule);
          }
        },
        child: Container(
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
                  Text(_habit.title, style: const TextStyle(fontSize: 15)),
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
                    child: Icon(widget.icon,
                        color: AppColors.darkPrimary, size: 30),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
