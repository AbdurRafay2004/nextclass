import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides application package information (version, build number).
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});
/// Provides the globally accessible SharedPreferences instance.
/// This MUST be overridden in ProviderScope before runApp.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Manages the application's font family state and persistence.
class SettingsNotifier extends Notifier<String> {
  static const _fontKey = 'selected_font_family';
  static const _defaultFont = 'Bricolage Grotesque';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_fontKey) ?? _defaultFont;
  }

  /// Updates the application font family and persists the choice.
  Future<void> setFontFamily(String fontFamily) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_fontKey, fontFamily);
    state = fontFamily;
  }
}

/// Exposes the currently selected font family.
final fontFamilyProvider = NotifierProvider<SettingsNotifier, String>(() {
  return SettingsNotifier();
});
