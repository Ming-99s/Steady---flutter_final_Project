import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/models/habit.dart';
import 'package:steady/widgets/HighlightCard.dart';
import 'package:steady/widgets/HighlightCardForSchedule.dart';
import 'package:steady/widgets/habitProgressDetail.dart';
import '../theme/appColor.dart';
import '../widgets/addOrEditScreen.dart';
import '../utils/enums.dart';
import '../repository/habitGlobal.dart';

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({
    super.key,
    required this.habit,
    required this.onRefresh,
  });
  final Habit habit;
  final Function() onRefresh;

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  final GlobalKey<HabitProgressDetailState> _progressKey =
      GlobalKey<HabitProgressDetailState>();
  final GlobalKey<HighlightSchedulecardState> _scheduleKey =
      GlobalKey<HighlightSchedulecardState>();

  @override
  Widget build(BuildContext context) {
    Future<bool?> showDeleteConfirmDialog(BuildContext context) {
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Habit'),
          content: const Text('Are you sure you want to delete this habit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Progress',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.getTextPrimary(context),
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.getTextPrimary(context)),
            onPressed: () async {
              final freshHabit = await habitRepo.getHabit(widget.habit.habitId);
              if (freshHabit == null) return;

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.getBackground(context),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                builder: (BuildContext context) {
                  return AddHabitScreen(
                    existingHabit: freshHabit,
                    onSave: () async {
                      // Reload again after save to update detail screen
                      final updated = await habitRepo.getHabit(
                        widget.habit.habitId,
                      );
                      if (updated != null && mounted) {
                        setState(() {});
                      }

                      widget.onRefresh();
                      _progressKey.currentState?.refresh();
                      _scheduleKey.currentState?.refresh();
                    },
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: AppColors.getTextPrimary(context),
              ),
              onPressed: () async {
                final confirmed = await showDeleteConfirmDialog(context);
                if (confirmed == true) {
                  await habitRepo.deleteHabit(
                    widget.habit.habitId,
                  ); // Delete from Hive
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Habit deleted')),
                  );
                  widget.onRefresh();
                  if (mounted) {
                    Navigator.pop(context); // safe to pop after calling refresh
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LAST 365 DAYS',
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              HabitProgressDetail(habit: widget.habit, key: _progressKey),
              SizedBox(height: 10),

              const Text(
                'HIGHLIGHTS',
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Highlightcard(
                      habit: widget.habit,
                      type: HighlightType.currentStreak,
                      icon: LineAwesomeIcons.fire_extinguisher_solid,
                      title: 'Current Streak',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Highlightcard(
                      habit: widget.habit,
                      type: HighlightType.bestStreak,
                      icon: LineAwesomeIcons.trophy_solid,
                      title: 'Best Streak',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Highlightcard(
                    habit: widget.habit,
                    type: HighlightType.completionCount,
                    icon: LineAwesomeIcons.check_circle_solid,
                    title: 'Completion',
                  ),
                  SizedBox(width: 12),
                  HighlightSchedulecard(
                    habit: widget.habit,
                    icon: LineAwesomeIcons.calendar,
                    title: 'Streak Goal',
                    key: _scheduleKey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
