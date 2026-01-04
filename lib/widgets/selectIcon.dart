import 'package:flutter/material.dart';
import 'package:steady/theme/appColor.dart';
import '../utils/iconData.dart';

class IconSelectionBottomSheet extends StatelessWidget {
  final String? selectedKey;

  const IconSelectionBottomSheet({super.key, required this.selectedKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Choose an icon", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.textPrimary)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
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
                      color: isSelected ? AppColors.primary: AppColors.background,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
                    ),
                    child: Icon(iconData, size: 32, color: isSelected ? AppColors.secondary : AppColors.textPrimary,fontWeight: FontWeight.w500,),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}