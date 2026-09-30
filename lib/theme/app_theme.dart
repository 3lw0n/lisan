import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1B5E5A);
  static const Color completed = Color(0xFFC8E6C9);
  static const Color completedBorder = Color(0xFF2E7D32);

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      useMaterial3: true,
      // خط عربي مضمَّن في التطبيق: يضمن شكل الحرف واتساقه على كل جهاز
      fontFamily: 'NotoNaskhArabic',
      // العربية تحتاج ارتفاع سطر أوسع وإلا تُقتطع رؤوس الحروف ونقاطها
      textTheme: const TextTheme(
        displayLarge: TextStyle(height: 1.7),
        displayMedium: TextStyle(height: 1.7),
        headlineSmall: TextStyle(height: 1.7),
        titleMedium: TextStyle(height: 1.6),
        bodyMedium: TextStyle(height: 1.6),
        bodyLarge: TextStyle(height: 1.6),
        labelLarge: TextStyle(height: 1.5),
      ),
    );
  }
}
