import 'package:flutter/material.dart';

class AppTheme {
  // 라이트 테마 색상
  static const Color _lightSeedColor = Color(0xFF6750A4);
  static const Color _lightPrimary = Color(0xFF6750A4);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightSecondary = Color(0xFF625B71);
  static const Color _lightOnSecondary = Color(0xFFFFFFFF);
  static const Color _lightTertiary = Color(0xFF7D5260);
  static const Color _lightOnTertiary = Color(0xFFFFFFFF);
  static const Color _lightError = Color(0xFFBA1A1A);
  static const Color _lightOnError = Color(0xFFFFFFFF);
  static const Color _lightBackground = Color(0xFFFFFBFE);
  static const Color _lightOnBackground = Color(0xFF1C1B1F);
  static const Color _lightSurface = Color(0xFFFFFBFE);
  static const Color _lightOnSurface = Color(0xFF1C1B1F);

  // 다크 테마 색상
  static const Color _darkSeedColor = Color(0xFFD0BCFF);
  static const Color _darkPrimary = Color(0xFFD0BCFF);
  static const Color _darkOnPrimary = Color(0xFF381E72);
  static const Color _darkSecondary = Color(0xFFCCC2DC);
  static const Color _darkOnSecondary = Color(0xFF332D41);
  static const Color _darkTertiary = Color(0xFFEFB8C8);
  static const Color _darkOnTertiary = Color(0xFF492532);
  static const Color _darkError = Color(0xFFFFB4AB);
  static const Color _darkOnError = Color(0xFF690005);
  static const Color _darkBackground = Color(0xFF1C1B1F);
  static const Color _darkOnBackground = Color(0xFFE6E1E5);
  static const Color _darkSurface = Color(0xFF1C1B1F);
  static const Color _darkOnSurface = Color(0xFFE6E1E5);

  // 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightSeedColor,
        brightness: Brightness.light,
        primary: _lightPrimary,
        onPrimary: _lightOnPrimary,
        secondary: _lightSecondary,
        onSecondary: _lightOnSecondary,
        tertiary: _lightTertiary,
        onTertiary: _lightOnTertiary,
        error: _lightError,
        onError: _lightOnError,
        background: _lightBackground,
        onBackground: _lightOnBackground,
        surface: _lightSurface,
        onSurface: _lightOnSurface,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }

  // 다크 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkSeedColor,
        brightness: Brightness.dark,
        primary: _darkPrimary,
        onPrimary: _darkOnPrimary,
        secondary: _darkSecondary,
        onSecondary: _darkOnSecondary,
        tertiary: _darkTertiary,
        onTertiary: _darkOnTertiary,
        error: _darkError,
        onError: _darkOnError,
        background: _darkBackground,
        onBackground: _darkOnBackground,
        surface: _darkSurface,
        onSurface: _darkOnSurface,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}
