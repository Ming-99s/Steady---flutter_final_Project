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
  final TextEditingController _timePerDayController =TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Schedule _selectedLoop = Schedule.everyday;
  Set<String> _selectedDays = {};
  String? _selectedIconKey;

  IconData get _currentIcon => _selectedIconKey != null
      ? iconMap[_selectedIconKey]!
      : LineAwesomeIcons.question_circle_solid;

  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
          color: isSelected ? AppColors.primary : AppColors.background,
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? AppColors.secondary : AppColors.textPrimary,
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

    final timePerDay = int.tryParse(_timePerDayController.text) ?? 1;
    if (timePerDay < 1 || timePerDay > 99) {
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
        description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
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
                  child: Text("Dismiss", style: TextStyle(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: _createAndSaveHabit,
                  child: const Text("Add", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
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
                      const Text("New Habit", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 20),

                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("INFO", style: TextStyle(fontSize: 10, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(hintText: "Title", border: InputBorder.none, contentPadding: EdgeInsets.zero),
                              style: const TextStyle(fontSize: 16),
                              validator: (value) => value?.trim().isEmpty ?? true ? "Please enter a habit title" : null,
                            ),
                            const Divider(height: 20),
                            TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(hintText: "Description", border: InputBorder.none, contentPadding: EdgeInsets.zero),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Divider(height: 20),
                            // Time per Day Field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Time per day", style: TextStyle(fontSize: 14)),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller: _timePerDayController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    decoration: const InputDecoration(
                                      hintText: "1",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      suffixText: " time",
                                      suffixStyle: TextStyle(color: Colors.grey),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return "Required";
                                      final n = int.tryParse(value);
                                      if (n == null || n < 1 || n > 99) return "1-99";
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Select the start date", style: TextStyle(fontSize: 14)),
                                GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) setState(() => _selectedDate = picked);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                                    child: Text("${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}", style: const TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("GOAL", style: TextStyle(fontSize: 10, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Schedule", style: TextStyle(fontSize: 14)),
                            DropdownButton<Schedule>(
                              dropdownColor: AppColors.background,
                              value: _selectedLoop,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.unfold_more, color: AppColors.offNav),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedLoop = value;
                                    if (value != Schedule.specificDay) _selectedDays.clear();
                                  });
                                }
                              },
                              items: Schedule.values.map((e) => DropdownMenuItem(value: e, child: Text(scheduleLabel(e)))).toList(),
                            ),
                          ],
                        ),
                      ),

                      if (_selectedLoop == Schedule.specificDay) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Select Days", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _daysOfWeek.map(_buildDayButton).toList()),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("ICON", style: TextStyle(fontSize: 10, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Pick an icon", style: TextStyle(fontSize: 14)),
                            GestureDetector(
                              onTap: () async {
                                final result = await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  builder: (_) => IconSelectionBottomSheet(selectedKey: _selectedIconKey),
                                );
                                if (result != null) setState(() => _selectedIconKey = result);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                                child: Icon(_currentIcon, size: 28),
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