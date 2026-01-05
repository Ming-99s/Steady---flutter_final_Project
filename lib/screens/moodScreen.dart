import 'package:flutter/material.dart';
import 'package:steady/screens/home.dart';
import '../theme/appColor.dart';
import '../widgets/moodWidget.dart';
import '../utils/app_pref.dart';
import '../utils/enums.dart';
import '../repository/quotes_repos.dart';
import '../models/quote.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selectedMood; // store the selected mood title
  Quote? _selectedQuote; // store the selected mood's quote

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

              // Quote Display Section
              // if (_selectedQuote != null)
              //   Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: AppColors.getSecondary(context),
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.2),
              //           blurRadius: 8,
              //           spreadRadius: 2,
              //         ),
              //       ],
              //     ),
              //     child: Column(
              //       children: [
              //         Text(
              //           _selectedQuote!.text,
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             color: AppColors.getTextPrimary(context),
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600,
              //             fontStyle: FontStyle.italic,
              //           ),
              //         ),
              //         const SizedBox(height: 12),
              //         Text(
              //           '— ${_selectedQuote!.author}',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             color: AppColors.getTextSecondary(context),
              //             fontSize: 14,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              const SizedBox(height: 30),

              // First Row
              Row(
                children: [
                  Expanded(
                    child: Moodwidget(
                      image: MoodType.motivate.image,
                      title: MoodType.motivate.title,
                      isSelected: _selectedMood == MoodType.motivate.title,
                      onTap: () async {
                        final quote = await QuotesRepository.getQuoteByMood(
                          MoodType.motivate.title,
                        );
                        setState(() {
                          _selectedMood = MoodType.motivate.title;
                          _selectedQuote = quote;
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
                      onTap: () async {
                        final quote = await QuotesRepository.getQuoteByMood(
                          MoodType.tired.title,
                        );
                        setState(() {
                          _selectedMood = MoodType.tired.title;
                          _selectedQuote = quote;
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
                      onTap: () async {
                        final quote = await QuotesRepository.getQuoteByMood(
                          MoodType.normal.title,
                        );
                        setState(() {
                          _selectedMood = MoodType.normal.title;
                          _selectedQuote = quote;
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
                      onTap: () async {
                        final quote = await QuotesRepository.getQuoteByMood(
                          MoodType.stressed.title,
                        );
                        setState(() {
                          _selectedMood = MoodType.stressed.title;
                          _selectedQuote = quote;
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
