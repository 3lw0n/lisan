import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1B5E5A);
  static const Color completed = Color(0xFFC8E6C9);
  static const Color completedBorder = Color(0xFF2E7D32);

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      useMaterial3: true,
    );
  }
}
