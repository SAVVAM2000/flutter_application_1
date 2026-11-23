import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ThemeColors.white,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
    );
  }
}

final _colorScheme = ColorScheme.fromSeed(
  seedColor: ThemeColors.accent,
);

final _appBarTheme = const AppBarTheme(
  toolbarHeight: 50,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: true,
  // Иконки на тёмной панели (стрелка «назад») должны быть белыми.
  iconTheme: IconThemeData(color: ThemeColors.white),
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ThemeColors.white,
  ),
  backgroundColor: ThemeColors.black,
);
