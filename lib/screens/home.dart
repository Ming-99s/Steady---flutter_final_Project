import 'package:flutter/material.dart';
import 'package:steady/screens/tab/TrackerScreen.dart';
import 'package:steady/screens/tab/addScreen.dart';
import 'package:steady/screens/tab/setting.dart';
import '../utils/enums.dart';
import './tab/HomeScreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    AllTab currentTab = AllTab.home;
    return Scaffold(
      body: IndexedStack(
        index: currentTab.index,
        children: [
          Homescreen(),
          AddHabitScreen(),
          Trackerscreen(),
          Setting()
        ],
      ),
    );
  }
}