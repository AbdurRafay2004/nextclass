import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared text styles for consistent typography across all pages.
class AppTextStyles {
  /// Uppercase section headers (e.g., "UP NEXT TODAY", "APPEARANCE", "CLASS SESSIONS").
  static TextStyle sectionHeader(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
      color: AppColors.mutedText(context),
    );
  }

  /// Small uppercase tracking labels (e.g., "ROOM", "FACULTY ACRONYM", "TIME REMAINING").
  static TextStyle labelUppercase(BuildContext context) {
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.0,
      color: AppColors.mutedText(context),
    );
  }

  /// Bold card/tile title.
  static TextStyle cardTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Muted card subtitle / secondary info.
  static TextStyle cardSubtitle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.labelMedium!.copyWith(color: AppColors.mutedText(context));
  }
}
