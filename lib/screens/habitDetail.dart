import 'package:flutter/material.dart';
import 'package:steady/models/habit.dart';
import 'package:steady/widgets/habitProgressDetail.dart';
import '../theme/appColor.dart';
import '../widgets/addOrEditScreen.dart';
class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habit});
  final Habit habit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Progress',style: TextStyle(fontWeight: FontWeight.w800,color: AppColors.textPrimary),),
        
        
          actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.textPrimary),
            onPressed: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.getBackground(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (BuildContext context) {
                          return AddHabitScreen(existingHabit: habit,);
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.delete, color: AppColors.textPrimary),
              onPressed: () {
                // action button, e.g., delete habit
              },
            ),
          ),
        ],
        
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15 ,vertical: 10),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LAST 365 DAYS',style: TextStyle(color: AppColors.darkTextSecondary,fontSize: 15),),
              SizedBox(height: 10,),
              HabitProgressDetail(habit: habit)
            ]),
        ),
      
    );
  }
}
