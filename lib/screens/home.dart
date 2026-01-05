import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/screens/tab/HomeScreen.dart';
import 'package:steady/screens/tab/TrackerScreen.dart';
import 'package:steady/screens/tab/setting.dart';
import 'package:steady/theme/appColor.dart';
import '../models/habit.dart';
import '../utils/enums.dart';
import '../repository/habitGlobal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AllTab currentTab = AllTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getSecondary(context),

      body: AnimatedBuilder(
        animation: habitRepo,
        builder: (context, _) {
          final List<Habit> habits = habitRepo.getAllHabits();

          return IndexedStack(
            index: currentTab.index,
            children: [
              Homescreen(habits: habits),
              Trackerscreen(habits: habits),
              const Setting(),
            ],
          );
        },
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: AppColors.getSecondary(context),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(44, 0, 0, 0),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab.index,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.offNav,
          onTap: (index) {
            setState(() {
              currentTab = AllTab.values[index];
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.building),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.history_solid),
              label: 'Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.sliders_h_solid),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
