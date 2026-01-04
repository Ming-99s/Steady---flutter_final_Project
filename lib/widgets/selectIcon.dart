import 'package:flutter/material.dart';
import 'package:steady/theme/appColor.dart';
import '../utils/iconData.dart';

class IconSelectionBottomSheet extends StatelessWidget {
  final String? selectedKey;

  const IconSelectionBottomSheet({super.key, required this.selectedKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.getCardBackground(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose an icon",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: iconMap.length,
                itemBuilder: (context, index) {
                  final entry = iconMap.entries.elementAt(index);
                  final key = entry.key;
                  final iconData = entry.value;
                  final isSelected = key == selectedKey;

                  return GestureDetector(
                    onTap: () => Navigator.pop(context, key),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.getPrimary(context)
                            : AppColors.getBackground(context),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.getPrimary(context),
                                width: 3,
                              )
                            : null,
                      ),
                      child: Icon(
                        iconData,
                        size: 32,
                        color: isSelected
                            ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : AppColors.secondary)
                            : AppColors.getTextPrimary(context),
                        weight: 500,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
