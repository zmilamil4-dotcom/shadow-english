import 'package:flutter/material.dart';

class AppTheme {
  // Kept for splash_screen.dart compatibility
  static const Color primaryColor = Color(0xFF8B5CF6);

  static const Color background = Color(0xFF0B0B1F);
  static const Color surface = Color(0xFF15162E);
  static const Color surfaceLight = Color(0xFF1E1F3B);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color textPrimary = Color(0xFFF5F5FF);
  static const Color textSecondary = Color(0xFFA0A0C5);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [accentPurple, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [accentPink, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration cardDecoration({Color? color, double radius = 24}) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration glowDecoration({
    required LinearGradient gradient,
    double radius = 24,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: accentPurple.withOpacity(0.4),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentPurple,
      brightness: Brightness.dark,
    ).copyWith(secondary: accentBlue, surface: surface),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: textSecondary),
      bodyLarge: TextStyle(color: textPrimary),
      bodySmall: TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    dividerColor: Colors.white12,
  );
}
