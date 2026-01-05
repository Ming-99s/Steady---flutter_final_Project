import 'package:flutter/material.dart';
import 'package:steady/screens/home.dart';
import '../theme/appColor.dart';
import '../widgets/moodWidget.dart';
import '../utils/app_pref.dart';
import '../utils/enums.dart';
import '../models/quote.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selectedMood; // store the selected mood title
  Quote? _selectedQuote; // store the selected mood's quote

  // Map moods to their corresponding quotes
  final Map<String, Quote> _moodQuotes = {
    MoodType.motivate.title: Quote(
      id: '1',
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
      createdAt: DateTime.now(),
    ),
    MoodType.tired.title: Quote(
      id: '2',
      text: "Don't watch the clock; do what it does. Keep going.",
      author: "Sam Levenson",
      createdAt: DateTime.now(),
    ),
    MoodType.normal.title: Quote(
      id: '3',
      text: "Low energy is okay. Start small today.",
      author: "Steady",
      createdAt: DateTime.now(),
    ),
    MoodType.stressed.title: Quote(
      id: '4',
      text: "Every accomplishment starts with the decision to try.",
      author: "John F. Kennedy",
      createdAt: DateTime.now(),
    ),
  };

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
                          _selectedQuote = _moodQuotes[MoodType.motivate.title];
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
                          _selectedQuote = _moodQuotes[MoodType.tired.title];
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
                          _selectedQuote = _moodQuotes[MoodType.normal.title];
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
                          _selectedQuote = _moodQuotes[MoodType.stressed.title];
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
                        await AppPrefs.setSelectedMood(_selectedMood!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Home()),
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
