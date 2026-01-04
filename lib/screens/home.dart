import 'package:flutter/material.dart';
import 'package:steady/screens/tab/TrackerScreen.dart';
import 'package:steady/screens/tab/setting.dart';
import 'package:steady/theme/appColor.dart';
import '../utils/enums.dart';
import './tab/HomeScreen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../models/habit.dart';
import '../repository/habits_repository.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final repo = HabitRepository();
    final loadedHabits = await repo.loadHabits();
    setState(() {
      habits = loadedHabits;
    });
  }

  AllTab currentTab = AllTab.home;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getSecondary(context),
      body: IndexedStack(
        index: currentTab.index,
        children: [
          Homescreen(habits: habits),
          Trackerscreen(habits: habits),
          Setting(),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: AppColors.getSecondary(context),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(44, 0, 0, 0),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: BottomNavigationBar(
            enableFeedback: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab.index,
            selectedItemColor: AppColors.getPrimary(context),
            unselectedItemColor: AppColors.getOffNav(context),
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
      ),
    );
  }
}
