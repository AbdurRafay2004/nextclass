import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/share_import_service.dart';
import '../../domain/schedule_share_dto.dart';
import '../providers/sharing_provider.dart';

/// Displays a preview of the scanned schedule data and lets the user
/// choose how to import it (Replace or Merge).
class SharePreviewScreen extends ConsumerWidget {
  final ScheduleShareDTO dto;

  const SharePreviewScreen({super.key, required this.dto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalSessions = dto.courses.fold<int>(
      0,
      (sum, c) => sum + c.sessions.length,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('IMPORT PREVIEW')),
      body: Column(
        children: [
          // ── Summary header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SCHEDULE FOUND',
                  style: AppTextStyles.sectionHeader(context),
                ),
                const SizedBox(height: 8),
                Text(
                  '${dto.courses.length} course${dto.courses.length == 1 ? '' : 's'} '
                  '• $totalSessions session${totalSessions == 1 ? '' : 's'}',
                  style: AppTextStyles.cardSubtitle(context),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version ${dto.version}',
                  style: AppTextStyles.cardSubtitle(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Course list ─────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              itemCount: dto.courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final course = dto.courses[index];
                return _PreviewCourseCard(course: course);
              },
            ),
          ),

          // ── Import actions ──────────────────────────────────────────
          _ImportActionBar(
            onReplace: () => _doImport(context, ref, ImportMode.replace),
            onMerge: () => _doImport(context, ref, ImportMode.merge),
          ),
        ],
      ),
    );
  }

  Future<void> _doImport(
    BuildContext context,
    WidgetRef ref,
    ImportMode mode,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          mode == ImportMode.replace ? 'Replace Courses?' : 'Merge Courses?',
        ),
        content: Text(
          mode == ImportMode.replace
              ? 'Matching courses will be overwritten with the imported data. '
                    'Other courses in your schedule will not be affected.'
              : 'New sessions will be added to matching courses. '
                    'Duplicate sessions will be skipped. '
                    'Other courses in your schedule will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(mode == ImportMode.replace ? 'Replace' : 'Merge'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final importService = ref.read(shareImportProvider);
      final result = await importService.import(dto, mode: mode);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading

      // Show result
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Import Complete'),
          content: Text(
            '✅ ${result.coursesAdded} course${result.coursesAdded == 1 ? '' : 's'} added\n'
            '🔄 ${result.coursesUpdated} course${result.coursesUpdated == 1 ? '' : 's'} updated\n'
            '📅 ${result.sessionsAdded} session${result.sessionsAdded == 1 ? '' : 's'} added\n'
            '⏭️ ${result.sessionsSkipped} session${result.sessionsSkipped == 1 ? '' : 's'} skipped',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Pop all the way back to root
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    }
  }
}

/// Card showing a single course in the import preview.
class _PreviewCourseCard extends StatelessWidget {
  final SharedCourse course;

  const _PreviewCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final courseColor = AppColors.hexToColor(course.colorHex);

    return Material(
      color: AppColors.cardSurface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: courseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(course.name, style: AppTextStyles.tileTitle()),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.code, style: AppTextStyles.cardSubtitle(context)),
                  const SizedBox(height: 2),
                  Text(
                    'Faculty: ${course.facultyAcronym}'
                    '${course.facultyFullName != null ? ' (${course.facultyFullName})' : ''}',
                    style: AppTextStyles.cardSubtitle(context),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${course.sessions.length} session${course.sessions.length == 1 ? '' : 's'}',
                    style: AppTextStyles.cardSubtitle(
                      context,
                    ).copyWith(color: AppColors.skyBlue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom bar with Replace and Merge buttons.
class _ImportActionBar extends StatelessWidget {
  final VoidCallback onReplace;
  final VoidCallback onMerge;

  const _ImportActionBar({required this.onReplace, required this.onMerge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.cardSurface(context),
        border: Border(top: BorderSide(color: AppColors.dividerColor(context))),
      ),
      child: Row(
        children: [
          // Replace button
          Expanded(
            child: OutlinedButton(
              onPressed: onReplace,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderDark),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppColors.formRadius),
                ),
              ),
              child: Text('Replace', style: AppTextStyles.actionButton()),
            ),
          ),
          const SizedBox(width: 12),
          // Merge button
          Expanded(
            child: FilledButton(
              onPressed: onMerge,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: AppColors.bgDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppColors.formRadius),
                ),
              ),
              child: Text(
                'Merge',
                style: AppTextStyles.actionButton().copyWith(
                  color: AppColors.bgDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
