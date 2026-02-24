import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../course/data/models/course.dart';
import '../../../course/presentation/providers/course_provider.dart';
import '../../data/share_encoder_service.dart';
import '../../domain/schedule_share_dto.dart';
import '../providers/sharing_provider.dart';
import 'share_qr_screen.dart';

/// Screen for selecting which courses to include in a selective export.
///
/// Features:
/// - Checkbox per course
/// - "Select All" toggle
/// - Live estimated QR size indicator
/// - Continue button (disabled when nothing selected)
class CourseSelectionScreen extends ConsumerWidget {
  const CourseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final selectedUuids = ref.watch(courseSelectionProvider);
    final estimatedSize = ref.watch(estimatedSizeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SELECT COURSES')),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (courses) {
          if (courses.isEmpty) {
            return Center(
              child: Text(
                'No courses to share.',
                style: AppTextStyles.emptyStateMessage(context),
              ),
            );
          }

          final allSelected = selectedUuids.length == courses.length;

          return Column(
            children: [
              // ── Select All toggle ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'COURSES (${courses.length})',
                      style: AppTextStyles.sectionHeader(context),
                    ),
                    GestureDetector(
                      onTap: () {
                        final notifier = ref.read(
                          courseSelectionProvider.notifier,
                        );
                        if (allSelected) {
                          notifier.clearAll();
                        } else {
                          notifier.selectAll(
                            courses.map((c) => c.uuid).toList(),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            allSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: allSelected
                                ? AppColors.skyBlue
                                : AppColors.mutedDark,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Select All',
                            style: AppTextStyles.cardSubtitle(context).copyWith(
                              color: allSelected
                                  ? AppColors.skyBlue
                                  : AppColors.mutedDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Course list ───────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final isSelected = selectedUuids.contains(course.uuid);
                    return _CourseCheckTile(
                      course: course,
                      isSelected: isSelected,
                      onToggle: () {
                        ref
                            .read(courseSelectionProvider.notifier)
                            .toggle(course.uuid);
                      },
                    );
                  },
                ),
              ),

              // ── Size indicator + Continue button ──────────────────────
              _BottomBar(
                selectedCount: selectedUuids.length,
                estimatedSize: estimatedSize,
                onContinue: selectedUuids.isEmpty
                    ? null
                    : () => _generateQr(context, ref, selectedUuids.toList()),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _generateQr(
    BuildContext context,
    WidgetRef ref,
    List<String> uuids,
  ) async {
    final encoder = ref.read(shareEncoderProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await encoder.encodeSelected(uuids);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading

      if (result.exceedsQrLimit) {
        _showSizeLimitDialog(context, result);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShareQrScreen(encodeResult: result),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to encode: $e')));
    }
  }

  void _showSizeLimitDialog(BuildContext context, EncodeResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Selection Too Large'),
        content: Text(
          'Selected courses produce ${result.byteSize} bytes, exceeding '
          'the safe QR limit of $kQrMaxBytes bytes.\n\n'
          'Try selecting fewer courses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// A single course row with a checkbox.
class _CourseCheckTile extends StatelessWidget {
  final Course course;
  final bool isSelected;
  final VoidCallback onToggle;

  const _CourseCheckTile({
    required this.course,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final courseColor = AppColors.hexToColor(course.colorHex);

    return Material(
      color: AppColors.cardSurface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        side: isSelected
            ? BorderSide(color: courseColor.withValues(alpha: 0.6), width: 1.5)
            : BorderSide.none,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Color dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: courseColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              // Course info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name, style: AppTextStyles.tileTitle()),
                    const SizedBox(height: 2),
                    Text(
                      course.code,
                      style: AppTextStyles.cardSubtitle(context),
                    ),
                  ],
                ),
              ),
              // Checkbox
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: isSelected ? courseColor : AppColors.mutedDark,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom bar with size indicator and continue button.
class _BottomBar extends StatelessWidget {
  final int selectedCount;
  final AsyncValue<int> estimatedSize;
  final VoidCallback? onContinue;

  const _BottomBar({
    required this.selectedCount,
    required this.estimatedSize,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.cardSurface(context),
        border: Border(top: BorderSide(color: AppColors.dividerColor(context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Size indicator
          if (selectedCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: estimatedSize.when(
                loading: () => Text(
                  'Estimating size…',
                  style: AppTextStyles.cardSubtitle(context),
                ),
                error: (_, __) => Text(
                  'Could not estimate size',
                  style: AppTextStyles.cardSubtitle(context),
                ),
                data: (bytes) {
                  final label = _sizeLabel(bytes);
                  final color = _sizeColor(bytes);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.data_usage_rounded, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        'Estimated QR size: $label ($bytes bytes)',
                        style: AppTextStyles.cardSubtitle(
                          context,
                        ).copyWith(color: color),
                      ),
                    ],
                  );
                },
              ),
            ),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                foregroundColor: AppColors.bgDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppColors.formRadius),
                ),
              ),
              child: Text(
                selectedCount == 0
                    ? 'Select at least one course'
                    : 'Generate QR ($selectedCount selected)',
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

  String _sizeLabel(int bytes) {
    if (bytes < 800) return 'Small';
    if (bytes < 1600) return 'Medium';
    return 'Large';
  }

  Color _sizeColor(int bytes) {
    if (bytes < 800) return AppColors.liveGreen;
    if (bytes < 1600) return AppColors.butterYellow;
    if (bytes <= kQrMaxBytes) return AppColors.coralRose;
    return AppColors.blushPink;
  }
}
