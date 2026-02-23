import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.mutedText(context);

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        children: [
          Text('PREFERENCES', style: AppTextStyles.sectionHeader(context)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardSurface(context),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Time Format', style: AppTextStyles.tileTitle()),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time_filled,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '12-Hour',
                        style: AppTextStyles.tileTrailing(context),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: muted),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('INFORMATION', style: AppTextStyles.sectionHeader(context)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardSurface(context),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('About', style: AppTextStyles.tileTitle()),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mutedText(
                        context,
                      ).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info, color: muted, size: 20),
                  ),
                  trailing: Icon(Icons.chevron_right, color: muted),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Version 2.3.1 (beta)',
              style: AppTextStyles.versionText(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
