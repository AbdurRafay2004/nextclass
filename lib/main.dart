import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/database_manager.dart';
import 'core/theme/app_theme.dart';
import 'features/schedule/presentation/pages/dashboard_page.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline Isar Database
  final isar = await DatabaseManager.init();

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(isar)],
      child: const NextClassApp(),
    ),
  );
}

class NextClassApp extends ConsumerWidget {
  const NextClassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We will later read ThemeMode from a Settings provider, but use system for now.
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'NextClass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const DashboardPage(),
    );
  }
}
