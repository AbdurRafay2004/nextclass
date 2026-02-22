import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/database_manager.dart';
import 'core/theme/app_theme.dart';
import 'features/schedule/presentation/pages/dashboard_page.dart';

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

class NextClassApp extends StatelessWidget {
  const NextClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextClass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const DashboardPage(),
    );
  }
}
