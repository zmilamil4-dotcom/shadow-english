import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // EchoSpeak Colors
  // =========================

  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color accentColor = Color(0xFF38BDF8);

  static const Color darkBackground = Color(0xFF0B1020);
  static const Color darkCard = Color(0xFF151B2E);

  static const Color lightBackground = Color(0xFFF6F7FF);

  // =========================
  // Light Theme
  // =========================

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: lightBackground,

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: lightBackground,
      foregroundColor: Color(0xFF111827),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
    ),
  );

  // =========================
  // Dark Theme
  // =========================

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: darkBackground,

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: darkCard,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: accentColor,
          width: 2,
        ),
      ),
    ),
  );
}
