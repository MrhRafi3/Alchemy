import 'package:flutter/material.dart';

/// Comprehensive design tokens and theming for the Alchemy application.
class AppTheme {
  // ============================================================
  // Alchemy Color Palette
  // ============================================================

  static const Color background = Color(0xFF07090E);
  static const Color backgroundSecondary = Color(0xFF0C1018);
  static const Color backgroundElevated = Color(0xFF101522);

  static const Color surface = Color(0xFF131924);
  static const Color surfaceLight = Color(0xFF1C2433);
  static const Color surfaceGlass = Color(0xCC131924);
  static const Color surfaceElevated = Color(0xFF222B3D);

  static const Color primaryText = Color(0xFFF6F8FC);
  static const Color secondaryText = Color(0xFF949EB2);
  static const Color tertiaryText = Color(0xFF636D80);

  static const Color accent = Color(0xFF8B7CFF);
  static const Color accentLight = Color(0xFFA599FF);
  static const Color accentGlow = Color(0x4D8B7CFF);

  static const Color gold = Color(0xFFFFC857);
  static const Color goldGlow = Color(0x4DFFC857);

  static const Color emerald = Color(0xFF4ECCA3);
  static const Color ruby = Color(0xFFFF5964);
  static const Color sapphire = Color(0xFF38B6FF);
  static const Color amethyst = Color(0xFFC77DFF);

  static const Color border = Color(0x1FFFFFFF);
  static const Color borderLight = Color(0x33FFFFFF);
  static const Color borderGlow = Color(0x408B7CFF);

  // ============================================================
  // Gradients
  // ============================================================

  static const LinearGradient alchemicalGlow = LinearGradient(
    colors: [Color(0xFF8B7CFF), Color(0xFF4EEBF2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldShimmer = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFFF9E00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient chamberGradient = LinearGradient(
    colors: [Color(0xFF181F2C), Color(0xFF0F141E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x28FFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================
  // Shadows & Glows
  // ============================================================

  static List<BoxShadow> glowShadow(
    Color color, {
    double radius = 16,
    double opacity = 0.3,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: radius,
        spreadRadius: 1,
      ),
    ];
  }

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  // ============================================================
  // Material 3 Dark Theme Configuration
  // ============================================================

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: gold,
        tertiary: sapphire,
        onSurface: primaryText,
        onPrimary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: backgroundSecondary.withValues(alpha: 0.95),
        elevation: 0,
        height: 68,
        indicatorColor: accent.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? primaryText : secondaryText,
            letterSpacing: 0.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? accentLight : secondaryText,
          );
        }),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: secondaryText,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          color: secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        textStyle: const TextStyle(color: primaryText, fontSize: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle: const TextStyle(color: primaryText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
