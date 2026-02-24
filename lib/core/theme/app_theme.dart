import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_text_styles.dart';

class AppTheme {
  // ── Shared component themes ─────────────────────────────────────────

  static AppBarTheme _appBarTheme(String fontFamily) => AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    titleTextStyle: AppTextStyles.pageHeader(null, fontFamily: fontFamily),
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
      borderSide: const BorderSide(color: AppColors.skyBlue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  static final DialogThemeData _dialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppColors.cardRadius),
    ),
  );

  // ── Dark Theme (only theme) ─────────────────────────────────────────

  static ThemeData darkTheme(String fontFamily) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surfaceDark,
        onSurface: AppColors.fgDark,
        primary: AppColors.skyBlue,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme: AppFonts.textTheme(
        fontFamily: fontFamily,
        base: ThemeData.dark().textTheme,
      ).apply(bodyColor: AppColors.fgDark, displayColor: AppColors.fgDark),
      appBarTheme: _appBarTheme(fontFamily),
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
