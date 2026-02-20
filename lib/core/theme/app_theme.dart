import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: AppColors.bgLight,
        surface: AppColors.surfaceLight,
        onBackground: AppColors.fgLight,
        onSurface: AppColors.fgLight,
        primary: AppColors.brandSkyBlue,
        outline: AppColors.borderLight,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: AppColors.fgLight,
        displayColor: AppColors.fgLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: AppColors.bgDark,
        surface: AppColors.surfaceDark,
        onBackground: AppColors.fgDark,
        onSurface: AppColors.fgDark,
        primary: AppColors.brandSkyBlue,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: AppColors.fgDark, displayColor: AppColors.fgDark),
    );
  }
}
