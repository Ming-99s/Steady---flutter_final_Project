import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/theme/appColor.dart';
import '../utils/iconData.dart';
import './selectIcon.dart';
import '../utils/enums.dart';
import '../utils/helper.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Schedule _selectedLoop = Schedule.everyday;
  Set<String> _selectedDays = {};
  String? _selectedIconKey;

  IconData get _currentIcon => _selectedIconKey != null
      ? iconMap[_selectedIconKey]!
      : LineAwesomeIcons.question_circle_solid;

  final List<String> _daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildDayButton(String day) {
    final isSelected = _selectedDays.contains(day);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(day);
          } else {
            _selectedDays.add(day);
          }
        });
      },
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.getBackground(context),
      child: SizedBox(
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
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('Title: ${_titleController.text}');
                      debugPrint('Description: ${_descriptionController.text}');
                      debugPrint('Start Date: $_selectedDate');
                      debugPrint('Schedule: $_selectedLoop');
                      debugPrint('Selected Days: ${_selectedDays.join(', ')}');
                      debugPrint('Icon Key: $_selectedIconKey');
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "INFO",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.getTextSecondary(context),
                            letterSpacing: 0.5,
                          ),
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
                            TextField(
                              controller: _titleController,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.getTextPrimary(context),
                              ),
                              decoration: InputDecoration(
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  color: AppColors.getTextPrimary(
                                    context,
                                  ).withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: AppColors.getBorder(context),
                            ),
                            TextField(
                              controller: _descriptionController,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getTextPrimary(context),
                              ),
                              decoration: InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(
                                  color: AppColors.getTextPrimary(
                                    context,
                                  ).withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: AppColors.getBorder(context),
                            ),
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
                                    final DateTime? picked =
                                        await showDatePicker(
                                          context: context,
                                          initialDate: _selectedDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                        );
                                    if (picked != null)
                                      setState(() => _selectedDate = picked);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.getBackground(context),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.getTextPrimary(
                                          context,
                                        ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "GOAL",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.getTextSecondary(context),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
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
                              dropdownColor: AppColors.getCardBackground(
                                context,
                              ),
                              value: _selectedLoop,
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.unfold_more,
                                color: AppColors.getOffNav(context),
                              ),
                              style: TextStyle(
                                color: AppColors.getTextPrimary(context),
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedLoop = value;
                                    if (value != Schedule.specificDay)
                                      _selectedDays.clear();
                                  });
                                }
                              },
                              items: Schedule.values.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(scheduleLabel(e)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      if (_selectedLoop == Schedule.specificDay) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _daysOfWeek
                                    .map(_buildDayButton)
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // ICON Section
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "ICON",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.getTextSecondary(context),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
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
                                final result =
                                    await showModalBottomSheet<String>(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          AppColors.getCardBackground(context),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (_) => IconSelectionBottomSheet(
                                        selectedKey: _selectedIconKey,
                                      ),
                                    );
                                if (result != null) {
                                  setState(() => _selectedIconKey = result);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.getBackground(context),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.getBorder(context),
                                  ),
                                ),
                                child: Icon(
                                  _currentIcon,
                                  size: 28,
                                  color: AppColors.getTextPrimary(context),
                                ),
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
          ],
        ),
      ),
    );
  }
}
