import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/database/database_manager.dart';
import 'core/theme/app_theme.dart';
import 'features/schedule/presentation/pages/dashboard_page.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline Isar Database
  final isar = await DatabaseManager.init();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(isar),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const NextClassApp(),
    ),
  );
}

class NextClassApp extends ConsumerWidget {
  const NextClassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontFamily = ref.watch(fontFamilyProvider);

    return MaterialApp(
      title: 'NextClass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(fontFamily),
      darkTheme: AppTheme.darkTheme(fontFamily),
      themeMode: ThemeMode.dark,
      home: const DashboardPage(),
    );
  }
}
