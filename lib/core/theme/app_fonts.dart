import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized font configuration for the entire app.
///
/// Current font: **Bricolage Grotesque**
/// - Variable weight axis: 200–800
/// - Variable width axis: 75–100 (condensed → normal)
///
/// To change the app font, update [style] and [textTheme] below.
class AppFonts {
  /// Returns a [TextStyle] using the app font (Bricolage Grotesque).
  ///
  /// Use this instead of `GoogleFonts.bricolageGrotesque(...)` or raw `TextStyle(...)`.
  static TextStyle style({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.bricolageGrotesque(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  /// Returns a complete [TextTheme] using the app font.
  ///
  /// Used in [AppTheme] to set the base typography.
  static TextTheme textTheme([TextTheme? base]) {
    return GoogleFonts.bricolageGrotesqueTextTheme(base);
  }
}
