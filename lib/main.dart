import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady/screens/home.dart';
import 'package:steady/screens/moodScreen.dart';
import 'package:steady/screens/startScreen.dart';
import 'package:steady/theme/theme_provider.dart';
import './utils/app_pref.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './models/dialyProgress.dart';
import './models/habit.dart';
import './models/quote.dart';
import './repository/quotes_repos.dart';

// import './repository/habitGlobal.dart';
// import './utils/enums.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirstLaunch = await AppPrefs.isFirstLaunch();
  final shouldShowStartScreen = await AppPrefs.shouldShowStartScreen();
  final isMoodDoneToday = await AppPrefs.isMoodCompletedToday();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(DailyProgressAdapter());
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<DailyProgress>('daily_progress');
  await QuotesRepository.initializeQuotes();

  runApp(
    DevicePreview(
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Steady(
          isFirstLaunch: isFirstLaunch,
          shouldShowStartScreen: shouldShowStartScreen,
          isMoodDoneToday: isMoodDoneToday,
        ),
      ),
    ),
  );
}

class Steady extends StatelessWidget {
  final bool isFirstLaunch;
  final bool shouldShowStartScreen;
  final bool isMoodDoneToday;

  const Steady({
    super.key,
    required this.isFirstLaunch,
    required this.shouldShowStartScreen,
    required this.isMoodDoneToday,
  });

  @override
  Widget build(BuildContext context) {
    Widget startPage;

    if (isFirstLaunch) {
      startPage = Startscreen();
    } else if (shouldShowStartScreen) {
      startPage = Startscreen();
    } else if (isMoodDoneToday) {
      startPage = Home();
    } else {
      startPage = MoodScreen();
    }

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: startPage),
        );
      },
    );
  }
}
