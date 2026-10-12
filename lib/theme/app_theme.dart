import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // ALchemy Color System
  // ============================================================

  static const Color background = Color(0xFF07090D);
  static const Color backgroundSecondary = Color(0xFF0C1017);

  static const Color surface = Color(0xFF11161F);
  static const Color surfaceLight = Color(0xFF181E28);

  static const Color primaryText = Color(0xFFF4F6FA);
  static const Color secondaryText = Color(0xFF8D96A6);

  static const Color accent = Color(0xFF8B7CFF);

  static const Color border = Color(0x1AFFFFFF);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      surface: surface,
      primary: accent,
      secondary: accent,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface.withValues(alpha: 0.94),
      elevation: 0,
      indicatorColor: accent.withValues(alpha: 0.15),

      labelTextStyle: WidgetStateProperty.resolveWith(
            (states) {
          final selected = states.contains(
            WidgetState.selected,
          );

          return TextStyle(
            fontSize: 11,
            fontWeight:
            selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? primaryText
                : secondaryText,
          );
        },
      ),

      iconTheme: WidgetStateProperty.resolveWith(
            (states) {
          final selected = states.contains(
            WidgetState.selected,
          );

          return IconThemeData(
            size: 22,
            color: selected
                ? primaryText
                : secondaryText,
          );
        },
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: primaryText,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),

      headlineMedium: TextStyle(
        color: primaryText,
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ),

      titleLarge: TextStyle(
        color: primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),

      titleMedium: TextStyle(
        color: primaryText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      bodyLarge: TextStyle(
        color: primaryText,
        fontSize: 16,
      ),

      bodyMedium: TextStyle(
        color: secondaryText,
        fontSize: 14,
      ),

      labelSmall: TextStyle(
        color: secondaryText,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    ),
  );
}