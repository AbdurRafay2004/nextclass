import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized font configuration for the entire app.
///
/// To change the app font, update [style] and [textTheme] to use
/// a different GoogleFonts method (e.g., `GoogleFonts.poppins`).
class AppFonts {
  /// Returns a [TextStyle] using the app's chosen font (Inter).
  ///
  /// Use this instead of `GoogleFonts.inter(...)` or raw `TextStyle(...)`.
  static TextStyle style({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  /// Returns a complete [TextTheme] using the app's chosen font.
  ///
  /// Used in [AppTheme] to set the base typography.
  static TextTheme textTheme([TextTheme? base]) {
    return GoogleFonts.interTextTheme(base);
  }
}
