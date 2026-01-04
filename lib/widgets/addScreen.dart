// screens/add_habit_screen.dart
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/theme/appColor.dart';
import '../utils/iconData.dart';
import '../utils/enums.dart';
import '../utils/helper.dart';
import '../widgets/selectIcon.dart';
import '../repository/habitGlobal.dart'; // ← Global habitRepo

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timePerDayController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Schedule _selectedLoop = Schedule.everyday;
  Set<String> _selectedDays = {};
  String? _selectedIconKey;

  IconData get _currentIcon => _selectedIconKey != null
      ? iconMap[_selectedIconKey]!
      : LineAwesomeIcons.question_circle_solid;

  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String _getMonthName(int month) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return months[month - 1];
  }

  Widget _buildDayButton(String day) {
    final isSelected = _selectedDays.contains(day);
    return GestureDetector(
      onTap: () => setState(() => isSelected ? _selectedDays.remove(day) : _selectedDays.add(day)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.getPrimary(context)
              : AppColors.getBackground(context),
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 10,
            color: isSelected
                ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.secondary)
                : AppColors.getTextPrimary(context),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Future<void> _createAndSaveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLoop == Schedule.specificDay && _selectedDays.isEmpty) {
      _showSnackBar("Please select at least one day");
      return;
    }

    final timePerDay = int.tryParse(_timePerDayController.text.trim());
    if (timePerDay == null || timePerDay < 1 || timePerDay > 99) {
      _showSnackBar("Time per day must be between 1 and 99");
      return;
    }

    List<Day> scheduleDays = [];
    if (_selectedLoop == Schedule.everyday) {
      scheduleDays = Day.values;
    } else if (_selectedLoop == Schedule.weekend) {
      scheduleDays = [Day.saturday, Day.sunday];
    } else if (_selectedLoop == Schedule.specificDay) {
      scheduleDays = _selectedDays.map((abbr) {
        final lower = abbr.toLowerCase();
        return Day.values.firstWhere((d) => d.name.startsWith(lower));
      }).toList();
    }

    try {
      await habitRepo.createHabit(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        timePerDay: timePerDay,
        iconName: _selectedIconKey ?? 'question_circle',
        schedule: scheduleDays,
        startDate: _selectedDate,
      );

      if (mounted) {
        _showSnackBar("Habit created successfully!");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        print(e);
        _showSnackBar("Failed to save habit. Please try again.");
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timePerDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Dismiss",
                    style: TextStyle(color: AppColors.getTextSecondary(context)),
                  ),
                ),
                TextButton(
                  onPressed: _createAndSaveHabit,
                  child: Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextSecondary(context)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New Habit",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // INFO Section
                      Text(
                        "INFO",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.getTextSecondary(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.getCardBackground(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Title
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: "Title",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.getTextPrimary(context).withOpacity(0.5),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.getTextPrimary(context),
                              ),
                              validator: (value) => value?.trim().isEmpty ?? true
                                  ? "Please enter a habit title"
                                  : null,
                            ),
                            Divider(
                              height: 20,
                              color: AppColors.getBorder(context),
                            ),
                            // Description
                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                hintText: "Description",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.getTextPrimary(context).withOpacity(0.5),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: AppColors.getBorder(context),
                            ),
                            // Time per Day
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time per day",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller: _timePerDayController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter number",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      suffixText: " time",
                                      suffixStyle: TextStyle(color: Colors.grey),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) return "Required";
                                      final n = int.tryParse(value);
                                      if (n == null || n < 1 || n > 99) return "1-99";
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              color: AppColors.getBorder(context),
                            ),
                            // Start Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Select the start date",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        // Dark/light theme support
                                        return Theme(
                                          data: Theme.of(context).brightness == Brightness.dark
                                              ? ThemeData.dark()
                                              : ThemeData.light(),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) setState(() => _selectedDate = picked);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.getBackground(context),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // GOAL Section
                      Text(
                        "GOAL",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.getTextSecondary(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.getCardBackground(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Schedule",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                            DropdownButton<Schedule>(
                              dropdownColor: AppColors.getCardBackground(context),
                              value: _selectedLoop,
                              underline: const SizedBox(),
                              icon: Icon(Icons.unfold_more, color: AppColors.getOffNav(context)),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedLoop = value;
                                    if (value != Schedule.specificDay) _selectedDays.clear();
                                  });
                                }
                              },
                              items: Schedule.values.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(scheduleLabel(e)),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),

                      if (_selectedLoop == Schedule.specificDay) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.getCardBackground(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Days",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _daysOfWeek.map(_buildDayButton).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // ICON Section
                      Text(
                        "ICON",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.getTextSecondary(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.getCardBackground(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pick an icon",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: AppColors.getCardBackground(context),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (_) => IconSelectionBottomSheet(selectedKey: _selectedIconKey),
                                );
                                if (result != null) setState(() => _selectedIconKey = result);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.getBackground(context),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.getBorder(context)),
                                ),
                                child: Icon(_currentIcon, size: 28, color: AppColors.getTextPrimary(context)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
