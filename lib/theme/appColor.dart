import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF2563EB);
  static const secondary = Color(0xFFFFFFFF);

  // Background
  static const background = Color(0xFFEFF6FF);

  // Text
  static const textPrimary = Color(0xFF172554);
  static const textSecondary = Color(0xFF3B82F6);

  // UI
  static const border = Color(0xFFDBEAFE);
  static const error = Color(0xFFEF4444);
  static const offNav = Color(0xFF93C5FD);

  // Dark theme colors
  static const darkPrimary = Color(0xFF3B82F6);
  static const darkSecondary = Color(0xFF1F2937);
  static const darkBackground = Color(0xFF111827);
  static const darkTextPrimary = Color(0xFFE5E7EB);
  static const darkTextSecondary = Color(0xFF60A5FA);
  static const darkBorder = Color(0xFF374151);
  static const darkError = Color(0xFFDC2626);
  static const darkOffNav = Color(0xFF1E3A8A);
  static const darkCardBackground = Color(0xFF1F2937);

  // Helper method to get color based on theme
  static Color getColor(
    BuildContext context,
    Color lightColor,
    Color darkColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkColor : lightColor;
  }

  static Color getPrimary(BuildContext context) =>
      getColor(context, primary, darkPrimary);
  static Color getSecondary(BuildContext context) =>
      getColor(context, secondary, darkSecondary);
  static Color getBackground(BuildContext context) =>
      getColor(context, background, darkBackground);
  static Color getTextPrimary(BuildContext context) =>
      getColor(context, textPrimary, darkTextPrimary);
  static Color getTextSecondary(BuildContext context) =>
      getColor(context, textSecondary, darkTextSecondary);
  static Color getBorder(BuildContext context) =>
      getColor(context, border, darkBorder);
  static Color getError(BuildContext context) =>
      getColor(context, error, darkError);
  static Color getOffNav(BuildContext context) =>
      getColor(context, offNav, darkOffNav);
  static Color getCardBackground(BuildContext context) =>
      getColor(context, secondary, darkCardBackground);
}
