import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  SettingsState build() {
    // In a full app, load this from SharedPreferences or Isar
    return SettingsState();
  }

  void toggleTheme(bool isDark) {
    state = state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggleNotifications(bool isEnabled) {
    state = state.copyWith(notificationsEnabled: isEnabled);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
