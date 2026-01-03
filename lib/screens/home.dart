import 'package:flutter/material.dart';
import 'package:steady/screens/tab/TrackerScreen.dart';
import 'package:steady/screens/tab/setting.dart';
import 'package:steady/theme/appColor.dart';
import '../utils/enums.dart';
import './tab/HomeScreen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
      backgroundColor: AppColors.secondary,
      body: IndexedStack(
        index: currentTab.index,
        children: [Homescreen(), Trackerscreen(), Setting()],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(44, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory, // removes ripple
              highlightColor: Colors.transparent, // removes highlight
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
              items: [
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
      ),
    );
  }
}
