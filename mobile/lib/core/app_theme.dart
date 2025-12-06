import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette
  static const Color teal = Color(0xFF0E7C7B);
  static const Color amber = Color(0xFFFFB347);
  static const Color surface = Color(0xFFF7F5F2);
  static const Color success = Color(0xFF1E9E6A);
  static const Color danger = Color(0xFFD64550);
  static const Color textPrimary = Color(0xFF1F2933);
  static const Color textSecondary = Color(0xFF4B5563);

  static ThemeData theme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      primary: teal,
      secondary: amber,
      surface: surface,
      error: danger,
    );

    final baseTextTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
      fontFamilyFallback: const ['Noto Nastaliq Urdu'],
    );

    final textTheme = baseTextTheme.copyWith(
      titleLarge: baseTextTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2),
      titleMedium:
          baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall:
          baseTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge:
          baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: textPrimary),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: textSecondary),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: textTheme.bodyMedium
            ?.copyWith(color: textSecondary.withValues(alpha: 0.8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: teal,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: teal, width: 1.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: teal.withValues(alpha: 0.12),
        labelStyle: textTheme.bodyMedium!,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: const DividerThemeData(
          space: 1, thickness: 1, color: Color(0xFFE5E7EB)),
    );
  }
}
