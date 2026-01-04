import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steady/theme/theme_provider.dart';

class Switchstate extends StatelessWidget {
  const Switchstate({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch(
      value: themeProvider.isDarkMode,
      activeColor: Colors.blue,
      onChanged: (bool value) {
        themeProvider.toggleTheme();
      },
    );
  }
}
