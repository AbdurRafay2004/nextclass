import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Shared text styles for consistent typography across all pages.
class AppTextStyles {
  /// Uppercase section headers (e.g., "UP NEXT TODAY", "CLASS SESSIONS").
  static TextStyle sectionHeader(BuildContext context) {
    return AppFonts.style(
      fontSize: 12,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
      color: AppColors.mutedText(context),
    );
  }

  /// Small uppercase tracking labels (e.g., "ROOM", "FACULTY ACRONYM").
  static TextStyle labelUppercase(BuildContext context) {
    return AppFonts.style(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.0,
      color: AppColors.mutedText(context),
    );
  }

  /// Bold card/tile title.
  static TextStyle cardTitle(BuildContext context) {
    return AppFonts.style(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Muted card subtitle / secondary info.
  static TextStyle cardSubtitle(BuildContext context) {
    return AppFonts.style(fontSize: 12, color: AppColors.mutedText(context));
  }
}
