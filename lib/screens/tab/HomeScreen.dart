import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/theme/appColor.dart';
import 'package:steady/widgets/addScreen.dart';
import '../../widgets/habitCard.dart';
import '../../models/habit.dart';
import '../../repository/habits_repository.dart';
import '../../repository/daily_progress_repository.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key,required this.habits});
  final List<Habit> habits;
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.secondary, // background like appbar
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(169, 73, 72, 72),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 30), // shadow downwards
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Habits',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    // Icon(LineAwesomeIcons.plus_solid,size: 30,fontWeight: FontWeight.w900,)
                    IconButton(
                      icon: Icon(
                        LineAwesomeIcons.plus_solid,
                        size: 30,
                        fontWeight: FontWeight.w900,
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (BuildContext context) {
                          return AddHabitScreen();
                        },
                      ),
                    ),
                  ],
                ),

                Text(
                  'Low energy is okay. Start small today.',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),

          // The rest of the home screen content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: GridView.builder(
                padding: EdgeInsets.only(top: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 10,
                ),
                itemCount: widget.habits.length,
                itemBuilder: (context, index) {
                  return HabitCircleWidget(habit: widget.habits[index],);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
