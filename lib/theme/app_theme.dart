import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (from reference)
  static const Color primaryRed = Color(0xFFFF5E3A); // Deep orange/red for gradients
  static const Color accentOrange = Color(0xFFFF2A6D);
  static const Color darkGrey = Color(0xFF2C2C2E); // For buttons
  
  // Background & Surfaces
  static const Color bgLightGrey = Color(0xFFF3F4F6); // Soft off-white background
  static const Color pureWhite = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color trueBlack = Color(0xFF111111);
  static const Color greyText = Color(0xFF8E8E93);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgLightGrey,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: accentOrange,
        surface: pureWhite,
        onPrimary: pureWhite,
        onSecondary: pureWhite,
        onSurface: trueBlack,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLightGrey,
        foregroundColor: trueBlack,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
