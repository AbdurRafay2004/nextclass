import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_text_styles.dart';

class AppTheme {
  // ── Shared component themes ─────────────────────────────────────────

  static final AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    titleTextStyle: AppTextStyles.pageHeader(
      null as dynamic,
    ), // Context not used for static values in AppFonts.style
    iconTheme: const IconThemeData(color: AppColors.fgDark),
  );

  static final CardThemeData _cardTheme = CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppColors.cardRadius),
    ),
    elevation: 0,
  );

  static final InputDecorationTheme _inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppColors.formRadius),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppColors.formRadius),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppColors.formRadius),
      borderSide: const BorderSide(color: AppColors.brandSkyBlue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  static final DialogThemeData _dialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppColors.cardRadius),
    ),
  );

  // ── Dark Theme (only theme) ─────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surfaceDark,
        onSurface: AppColors.fgDark,
        primary: AppColors.brandSkyBlue,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme: AppFonts.textTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: AppColors.fgDark, displayColor: AppColors.fgDark),
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputTheme,
      dialogTheme: _dialogTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
