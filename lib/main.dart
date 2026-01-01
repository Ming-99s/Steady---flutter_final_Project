import 'package:flutter/material.dart';
import 'package:steady/screens/home.dart';
import 'package:steady/screens/moodScreen.dart';
import 'package:steady/screens/startScreen.dart';
import './utils/app_pref.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirstLaunch = await AppPrefs.isFirstLaunch();

  runApp(
    DevicePreview(
      builder: (context) =>
          Steady(isFirstLaunch: isFirstLaunch), // Wrap your app
    ),
  );
}

class Steady extends StatelessWidget {
  final bool isFirstLaunch;

  const Steady({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // Matches the 'family' name in pubspec.yaml
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: isFirstLaunch ? Startscreen() : MoodScreen()),
    );
  }
}
