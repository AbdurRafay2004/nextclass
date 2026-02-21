import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool notificationsEnabled;

  SettingsState({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({ThemeMode? themeMode, bool? notificationsEnabled}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _themeModeKey = 'theme_mode';
  static const _notificationsKey = 'notifications_enabled';

  @override
  SettingsState build() {
    // Load persisted settings asynchronously, then update state.
    _loadFromPrefs();
    return SettingsState();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    final notificationsEnabled = prefs.getBool(_notificationsKey);

    state = SettingsState(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex]
          : ThemeMode.system,
      notificationsEnabled: notificationsEnabled ?? true,
    );
  }

  void toggleTheme(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(themeMode: mode);
    _persist();
  }

  void toggleNotifications(bool isEnabled) {
    state = state.copyWith(notificationsEnabled: isEnabled);
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, state.themeMode.index);
    await prefs.setBool(_notificationsKey, state.notificationsEnabled);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
