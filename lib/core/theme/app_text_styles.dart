import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Shared text styles for consistent typography across all pages.
///
/// Bricolage Grotesque weight guide:
///   200 = ExtraLight, 300 = Light, 400 = Regular,
///   500 = Medium, 600 = SemiBold, 700 = Bold, 800 = ExtraBold
///
/// ALL text styling should go through this class. If you need a
/// new style, add it here — never create inline AppFonts.style() calls.
class AppTextStyles {
  // ── Navigation ──────────────────────────────────────────────────────

  /// Nav bar item labels (e.g., "FOCUS", "COURSES", "SETTINGS").
  static TextStyle navLabel({required Color color, String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: color,
      fontWeight: FontWeight.w800,
      fontSize: 9,
      letterSpacing: 2.0,
    );
  }

  // ── Page Headers ────────────────────────────────────────────────────

  /// Uppercase section headers (e.g., "UP NEXT TODAY", "CLASS SESSIONS",
  /// "APPEARANCE").
  static TextStyle sectionHeader(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: AppColors.mutedText(context),
    );
  }

  /// Consistent style for all page titles in the AppBar.
  /// Matches the minimal, uppercase, and muted look of the Focus page.
  static TextStyle pageHeader(BuildContext? context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: context != null
          ? AppColors.mutedText(context)
          : AppColors.mutedDark,
    );
  }

  // ── Cards ───────────────────────────────────────────────────────────

  /// Bold card/tile title (e.g., course name, session day).
  static TextStyle cardTitle(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Muted card subtitle / secondary info.
  static TextStyle cardSubtitle(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.mutedText(context),
    );
  }

  // ── Labels ──────────────────────────────────────────────────────────

  /// Small uppercase tracking labels (e.g., "ROOM", "FACULTY ACRONYM").
  static TextStyle labelUppercase(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: AppColors.mutedText(context),
    );
  }

  /// Inline badge text (e.g., "NOW" live indicator).
  static TextStyle badge(Color color, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: color,
      fontWeight: FontWeight.w800,
      fontSize: 8,
      letterSpacing: 1.5,
    );
  }

  /// Unit suffix text (e.g., "min" next to a number).
  static TextStyle unitSuffix(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: AppColors.mutedText(context),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  // ── List Tiles & Settings ───────────────────────────────────────────

  /// Settings / list tile title (e.g., "Dark Mode", "Time Format").
  static TextStyle tileTitle({String? fontFamily}) {
    return AppFonts.style(fontFamily: fontFamily, fontWeight: FontWeight.w600);
  }

  /// Settings trailing value text (e.g., "12-Hour", "Default").
  static TextStyle tileTrailing(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: AppColors.mutedText(context),
    );
  }

  /// Secondary info label (e.g., "Theme Color" on course detail).
  static TextStyle infoLabel(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: AppColors.mutedText(context),
      fontWeight: FontWeight.w600,
      fontSize: 13,
    );
  }

  // ── Buttons & Actions ──────────────────────────────────────────────

  /// Action button text (e.g., "Save" on AppBar).
  static TextStyle actionButton({String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );
  }

  /// Destructive action text (e.g., "DELETE", "Delete").
  static TextStyle destructiveAction(
    BuildContext context, {
    String? fontFamily,
  }) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: Theme.of(context).colorScheme.error,
    );
  }

  /// Day selector chip text (e.g., "M", "T", "W").
  static TextStyle dayChip({required Color color, String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  // ── Misc ────────────────────────────────────────────────────────────

  /// Session detail subtitle (e.g., "10:00 AM - 11:30 AM\nRoom: B-201").
  static TextStyle sessionDetail(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: AppColors.mutedText(context),
    );
  }

  /// Session day title in list (e.g., "Mondays").
  static TextStyle sessionDayTitle(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Version text at bottom of settings.
  static TextStyle versionText(BuildContext context, {String? fontFamily}) {
    return AppFonts.style(
      fontFamily: fontFamily,
      color: AppColors.mutedText(context),
      fontSize: 12,
    );
  }
}
