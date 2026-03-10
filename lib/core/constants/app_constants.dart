/// Centralized app constants for NextClass.
///
/// Use these constants instead of hardcoding values across the app.
/// This ensures consistency and makes updates easier.
class AppConstants {
  AppConstants._();

  /// App name displayed in UI.
  static const String appName = 'NextClass';

  /// Current app version (matches pubspec.yaml).
  static const String version = '5.5.0';

  /// Build number for version tracking.
  static const String buildNumber = '1';

  /// Full version string with build number (e.g., "5.5.0+1").
  static String get fullVersion => '$version+$buildNumber';

  /// App description shown in settings/about.
  static const String appDescription =
      'A clean, offline-first student schedule manager.';
}
