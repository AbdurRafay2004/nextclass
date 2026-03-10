import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../sharing/presentation/pages/export_mode_screen.dart';
import '../providers/settings_provider.dart';
import '../widgets/font_picker_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = AppColors.mutedText(context);
    final currentFont = ref.watch(fontFamilyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        children: [
          Text('APPEARANCE', style: AppTextStyles.sectionHeader(context)),
          const SizedBox(height: 16),
          Material(
            color: AppColors.cardSurface(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                ListTile(
                  title: Text('App Font', style: AppTextStyles.tileTitle()),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mutedDark.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.font_download,
                      color: AppColors.mutedDark,
                      size: 20,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentFont,
                        style: AppTextStyles.tileTrailing(context),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: muted),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FontPickerDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('SHARING', style: AppTextStyles.sectionHeader(context)),
          const SizedBox(height: 16),
          Material(
            color: AppColors.cardSurface(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Share Schedule',
                    style: AppTextStyles.tileTitle(),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mutedDark.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_rounded,
                      color: AppColors.mutedDark,
                      size: 20,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: muted),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ExportModeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('INFORMATION', style: AppTextStyles.sectionHeader(context)),
          const SizedBox(height: 16),
          Material(
            color: AppColors.cardSurface(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                ListTile(
                  title: Text('About', style: AppTextStyles.tileTitle()),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mutedDark.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info,
                      color: AppColors.mutedDark,
                      size: 20,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: muted),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: AppConstants.version,
                      applicationLegalese: AppConstants.appDescription,
                      children: [
                        const SizedBox(height: 16),
                        const Text('Built with Flutter & Isar.'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Version ${AppConstants.version}',
              style: AppTextStyles.versionText(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
