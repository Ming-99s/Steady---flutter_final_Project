import 'package:flutter/material.dart';
import 'package:steady/theme/appColor.dart';
import 'package:steady/models/habit.dart';
import 'package:steady/utils/enums.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _searchController;

  // Selected values
  IconData _selectedIcon = Icons.star;
  Set<Day> _selectedDays = {};
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  DateTime _startDate = DateTime.now();

  // Icon options organized by category
  final Map<String, List<IconData>> _categorizedIcons = {
    'Health & Fitness': [
      Icons.favorite,
      Icons.fitness_center,
      Icons.self_improvement,
      Icons.directions_run,
      Icons.sports_soccer,
      Icons.water_drop_outlined,
    ],
    'Food & Drink': [
      Icons.local_dining,
      Icons.restaurant,
      Icons.fastfood,
      Icons.coffee,
      Icons.local_bar,
      Icons.cake,
    ],
    'Productivity': [
      Icons.book,
      Icons.work,
      Icons.edit,
      Icons.checklist,
      Icons.schedule,
      Icons.laptop,
    ],
    'Entertainment': [
      Icons.music_note,
      Icons.brush,
      Icons.movie,
      Icons.games,
      Icons.theater_comedy,
      Icons.palette,
    ],
  };

  late List<IconData> _allIcons;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _searchController = TextEditingController();

    // Flatten all icons for search
    _allIcons = _categorizedIcons.values.expand((list) => list).toList();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addHabit() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit title')),
      );
      return;
    }

    final newHabit = Habit(
      habbitId: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      timePerDay: 30,
      icon: _selectedIcon,
      schedule: _selectedDays.toList(),
      startDate: _startDate,
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newHabit.title} added successfully!'),
        backgroundColor: AppColors.textSecondary,
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset form
    Future.delayed(const Duration(seconds: 1), () {
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedIcon = Icons.star;
        _selectedDays = {};
        _selectedTime = const TimeOfDay(hour: 9, minute: 0);
        _startDate = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                title: const Text(
                  'Create New Habit',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Title input
                    _buildInputField(
                      label: 'Habit Name',
                      hint: 'e.g., Morning Jog',
                      controller: _titleController,
                      icon: Icons.label,
                    ),
                    const SizedBox(height: 16),

                    // Description input
                    _buildInputField(
                      label: 'Description (Optional)',
                      hint: 'Why do you want this habit?',
                      controller: _descriptionController,
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Icon selector dropdown
                    _buildIconDropdown(),
                    const SizedBox(height: 24),

                    // Schedule days
                    _buildScheduleSelector(),
                    const SizedBox(height: 24),

                    // Start date
                    _buildStartDatePicker(),
                    const SizedBox(height: 32),

                    // Submit button
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Icon',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _showIconPicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.border, width: 1),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _selectedIcon,
                      color: AppColors.textSecondary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _getIconName(_selectedIcon),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showIconPicker() {
    _searchController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Select Icon',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border, width: 1),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Search field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Search icons',
                              hintStyle: TextStyle(color: AppColors.offNav.withOpacity(0.6)),
                              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(12),
                            ),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // Icons list
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          children: _buildIconCategories(setState),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> _buildIconCategories(StateSetter setState) {
    final searchQuery = _searchController.text.toLowerCase();
    final widgets = <Widget>[];

    _categorizedIcons.forEach((category, icons) {
      // Filter icons based on search
      final filteredIcons = icons
          .where((icon) =>
              _getIconName(icon).toLowerCase().contains(searchQuery) || searchQuery.isEmpty)
          .toList();

      if (filteredIcons.isEmpty) return;

      // Add category header
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            category,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      // Add icon grid
      widgets.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: filteredIcons.length,
          itemBuilder: (context, index) {
            final icon = filteredIcons[index];
            final isSelected = _selectedIcon == icon;

            return GestureDetector(
              onTap: () {
                this.setState(() => _selectedIcon = icon);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textSecondary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.textSecondary : AppColors.border,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.textSecondary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 32,
                    color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });

    return widgets;
  }

  String _getIconName(IconData icon) {
    const iconNames = {
      'water_drop_outlined': 'Water',
      'directions_run': 'Running',
      'book': 'Reading',
      'fitness_center': 'Fitness',
      'self_improvement': 'Meditation',
      'local_dining': 'Dining',
      'restaurant': 'Restaurant',
      'fastfood': 'Fast Food',
      'coffee': 'Coffee',
      'local_bar': 'Bar',
      'cake': 'Cake',
      'favorite': 'Love',
      'music_note': 'Music',
      'brush': 'Art',
      'sports_soccer': 'Sports',
      'work': 'Work',
      'edit': 'Edit',
      'checklist': 'Checklist',
      'schedule': 'Schedule',
      'laptop': 'Laptop',
      'movie': 'Movie',
      'games': 'Games',
      'theater_comedy': 'Theater',
      'palette': 'Palette',
    };
    final iconString = icon.toString();
    final iconName = iconString.replaceAll(RegExp(r'[^a-z_]'), '');
    return iconNames[iconName] ?? 'Icon';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.border.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.offNav.withOpacity(0.6)),
              prefixIcon: Icon(icon, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSelector() {
    final days = Day.values;
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
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
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textSecondary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.textSecondary : AppColors.border,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.textSecondary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    dayLabels[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (_selectedDays.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Selected Time',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _showTimePickerForAll,
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showTimePickerForAll() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.textSecondary,
              onPrimary: AppColors.secondary,
              surface: AppColors.secondary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildStartDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start Date',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.textSecondary,
                      onPrimary: AppColors.secondary,
                      surface: AppColors.secondary,
                      onSurface: AppColors.textPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() => _startDate = picked);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.border.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(
                  _formatDate(_startDate),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _addHabit,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.textSecondary, Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: AppColors.secondary, size: 24),
                SizedBox(width: 8),
                Text(
                  'Create Habit',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}