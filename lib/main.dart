import 'package:flutter/material.dart';
import 'package:steady/screens/home.dart';
import 'package:steady/screens/moodScreen.dart';
import 'package:steady/screens/startScreen.dart';
import './utils/app_pref.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './models/dialyProgress.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirstLaunch = await AppPrefs.isFirstLaunch();
  final isMoodDoneToday = await AppPrefs.isMoodCompletedToday();
  await Hive.initFlutter();
  Hive.registerAdapter(DailyProgressAdapter());
  await Hive.openBox<DailyProgress>('daily_progress');

  runApp(
    DevicePreview(
      builder: (context) =>
          Steady(isFirstLaunch: isFirstLaunch,isMoodDoneToday: isMoodDoneToday,), // Wrap your app
    ),
  );
}

class Steady extends StatelessWidget {
  final bool isFirstLaunch;
  final bool isMoodDoneToday;

  const Steady({super.key, required this.isFirstLaunch,required this.isMoodDoneToday});

  @override
  Widget build(BuildContext context) {
    Widget startPage;


    if (isFirstLaunch) {
      startPage = Startscreen();
    } else if (isMoodDoneToday) {
      startPage = Home();
    } else {
      startPage = MoodScreen();
    }
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // Matches the 'family' name in pubspec.yaml
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: startPage),
    );
  }
}
