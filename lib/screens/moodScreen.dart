import 'package:flutter/material.dart';
import 'package:steady/screens/home.dart';
import '../theme/appColor.dart';
import '../widgets/moodWidget.dart';
import '../utils/app_pref.dart';
import '../utils/enums.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selectedMood; // store the selected mood title

  @override
  Widget build(BuildContext context) {
    // List of moods

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Text(
                'How are you feeling today?',
                style: TextStyle(
                  color: AppColors.getTextPrimary(context),
                  fontSize: 23.7,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your mood shapes your journey.',
                style: TextStyle(
                  color: AppColors.getTextSecondary(context),
                  fontSize: 16.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              // First Row
              Row(
                children: [
                  Expanded(
                    child: Moodwidget(
                      image: MoodType.motivate.image,
                      title: MoodType.motivate.title,
                      isSelected: _selectedMood == MoodType.motivate.title,
                      onTap: () {
                        setState(() {
                          _selectedMood = MoodType.motivate.title;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Moodwidget(
                      image: MoodType.tired.image,
                      title: MoodType.tired.title,
                      isSelected: _selectedMood == MoodType.tired.title,
                      onTap: () {
                        setState(() {
                          _selectedMood = MoodType.tired.title;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Second Row
              Row(
                children: [
                  Expanded(
                    child: Moodwidget(
                      image: MoodType.normal.image,
                      title: MoodType.normal.title,
                      isSelected: _selectedMood == MoodType.normal.title,
                      onTap: () {
                        setState(() {
                          _selectedMood = MoodType.normal.title;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Moodwidget(
                      image: MoodType.stressed.image,
                      title: MoodType.stressed.title,
                      isSelected: _selectedMood == MoodType.stressed.title,
                      onTap: () {
                        setState(() {
                          _selectedMood = MoodType.stressed.title;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: _selectedMood == null
                    ? null
                    : () async {
                        await AppPrefs.setMoodCompletedToday();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Home()),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: AppColors.getPrimary(context),
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.secondary,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
