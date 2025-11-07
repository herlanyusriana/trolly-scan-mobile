import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark {
    const primaryBlue = Color(0xFF1D4ED8);
    const surfaceDark = Color(0xFF0F172A);

    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: surfaceDark,
      primaryColor: primaryBlue,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryBlue,
        secondary: const Color(0xFF38BDF8),
        surface: const Color(0xFF1E293B),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Roboto',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF0B1530),
        elevation: 0,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
