import 'package:flutter/material.dart';

class AppTheme {
  static const Color royalBlue = Color(0xFF1D5EFF);
  static const Color trueBlack = Color(0xFF0D0D0D);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color accentYellow = Color(0xFFFFE800);
  static const Color lightBlueBg = Color(0xFF427BFF);
  static const Color greyText = Color(0xFF888888);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: pureWhite,
      colorScheme: const ColorScheme.light(
        primary: royalBlue,
        secondary: accentYellow,
        surface: pureWhite,
        onPrimary: pureWhite,
        onSecondary: trueBlack,
        onSurface: trueBlack,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: pureWhite,
        foregroundColor: trueBlack,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
