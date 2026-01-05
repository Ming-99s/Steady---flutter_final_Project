import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/theme/appColor.dart';
import 'package:steady/widgets/addOrEditScreen.dart';
import '../../widgets/habitCard.dart';
import '../../models/habit.dart';
import '../../models/quote.dart';
import '../../utils/app_pref.dart';
import '../../repository/quotes_repos.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key, required this.habits});
  final List<Habit> habits;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Quote? _savedQuote;

  @override
  void initState() {
    super.initState();
    _loadSavedQuote();
  }

  Future<void> _loadSavedQuote() async {
    final savedMood = await AppPrefs.getSelectedMood();
    print('Saved mood: $savedMood');
    if (savedMood != null && mounted) {
      final quote = await QuotesRepository.getQuoteByMood(savedMood);
      print('Loaded quote: ${quote?.text}');
      if (quote != null) {
        setState(() {
          _savedQuote = quote;
        });
      } else {
        // Fallback: load any quote if mood-based loading fails
        final randomQuote = await QuotesRepository.getRandomQuote();
        if (randomQuote != null && mounted) {
          setState(() {
            _savedQuote = randomQuote;
          });
        }
      }
    }
  }

  /// Get only habits that should appear today
  List<Habit> get _todayHabits {
    final today = DateTime.now().weekday; // 1=Mon, 7=Sun
    return widget.habits.where((habit) {
      // habit.scheduleIndices is List<int> of Day index (0=Mon)
      return habit.scheduleIndices.contains(today - 1);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final todayHabits = _todayHabits;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.getSecondary(context),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(169, 73, 72, 72),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 30),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Habits',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        LineAwesomeIcons.plus_solid,
                        size: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.getTextPrimary(context),
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.getBackground(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (_) => AddHabitScreen(),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    _savedQuote?.text ??
                        'Low energy is okay. Start small today.',
                    style: TextStyle(color: AppColors.getTextPrimary(context)),
                  ),
                ),

                //  Test
                // child: TextButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return QuoteWidget();
                //       },
                //     );
                //   },
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           const Text(
                //             'Habits',
                //             style: TextStyle(
                //               fontWeight: FontWeight.w800,
                //               fontSize: 30,
                //             ),
                //           ),
                //           IconButton(
                //             icon: Icon(
                //               LineAwesomeIcons.plus_solid,
                //               size: 30,
                //               fontWeight: FontWeight.w900,
                //               color: AppColors.getTextPrimary(context),
                //             ),
                //             onPressed: () => showModalBottomSheet(
                //               context: context,
                //               backgroundColor: AppColors.getBackground(context),
                //               shape: const RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.vertical(
                //                   top: Radius.circular(10),
                //                 ),
                //               ),
                //               isScrollControlled: true,
                //               useSafeArea: true,
                //               builder: (_) => AddHabitScreen(),
                //             ),
                //           ),
                //         ],
                //       ),
                //       Text(
                //         'Low energy is okay. Start small today.',
                //         style: TextStyle(color: AppColors.getTextPrimary(context)),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),

          // Habits Grid
          Expanded(
            child: Container(
              color: AppColors.getBackground(context),
              child: todayHabits.isEmpty
                  ? Center(
                      child: Text(
                        "No habits for today",
                        style: TextStyle(
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: todayHabits.length,
                      itemBuilder: (context, index) {
                        final habit = todayHabits[index];
                        return HabitCircleWidget(
                          key: ValueKey(habit.habitId),
                          habit: habit,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
