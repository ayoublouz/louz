import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8D9EFF)),
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF9FAFC),
      cardTheme: const CardTheme(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
