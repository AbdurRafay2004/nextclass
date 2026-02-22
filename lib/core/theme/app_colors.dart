import 'package:flutter/material.dart';

class AppColors {
  // ── Utility Methods ──────────────────────────────────────────────────

  /// Converts a hex color string (e.g., '#87CEEB' or '87CEEB') to a [Color].
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Converts a [Color] to a hex string (e.g., '#87CEEB').
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2, 8).toUpperCase()}';
  }

  // ── Brand Palette (Pastels for Course Colors) ────────────────────────

  static const Color brandSkyBlue = Color(0xFF87CEEB);
  static const Color brandSoftPink = Color(0xFFFFB6C1);
  static const Color brandMintGreen = Color(0xFF98FF98);
  static const Color brandPeach = Color(0xFFFFCBA4);
  static const Color brandLavender = Color(0xFFE6D5FF);
  static const Color brandCoral = Color(0xFFFF7F7F);
  static const Color brandButterYellow = Color(0xFFFFFACD);
  static const Color brandSageGreen = Color(0xFF9DC183);
  static const Color brandPeriwinkle = Color(0xFFCCCCFF);
  static const Color brandSalmon = Color(0xFFFA8072);

  static const List<Color> courseColors = [
    brandSkyBlue,
    brandSoftPink,
    brandMintGreen,
    brandPeach,
    brandLavender,
    brandCoral,
    brandButterYellow,
    brandSageGreen,
    brandPeriwinkle,
    brandSalmon,
  ];

  // ── UI Palette - Shared ──────────────────────────────────────────────

  /// Elevated card background used by DynamicNavBar, LiveStatusCard,
  /// and TimelineEventCard in dark mode.
  static const Color cardDark = Color(0xFF222224);

  /// The "NOW" badge / live-indicator green.
  static const Color liveGreen = Color(0xFF00E676);

  /// Inactive icon/label color in the navigation bar.
  static const Color navInactive = Color(0xFF64748B);

  // ── UI Palette - Light Mode (retained for potential future use) ─────

  static const Color bgLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color fgLight = Color(0xFF11181C);
  static const Color mutedLight = Color(0xFF687076);
  static const Color borderLight = Color(0xFFE5E7EB);

  // ── UI Palette - Dark Mode ───────────────────────────────────────────

  static const Color bgDark = Color(0xFF151718);
  static const Color surfaceDark = Color(0xFF1E2022);
  static const Color fgDark = Color(0xFFECEDEE);
  static const Color mutedDark = Color(0xFF9BA1A6);
  static const Color borderDark = Color(0xFF334155);

  // ── Standardized Border Radii ───────────────────────────────────────

  /// Card border radius (course cards, timeline cards, live card, settings groups).
  static const double cardRadius = 20.0;

  /// Form container / input border radius.
  static const double formRadius = 16.0;

  // ── Context-Aware Helpers ───────────────────────────────────────────

  /// Card/surface background (dark-only app).
  static Color cardSurface(BuildContext context) => cardDark;

  /// Muted text color (dark-only app).
  static Color mutedText(BuildContext context) => mutedDark;

  /// Primary foreground text color (dark-only app).
  static Color primaryText(BuildContext context) => fgDark;

  /// Divider color (dark-only app).
  static Color dividerColor(BuildContext context) => borderDark;
}
