import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/share_encoder_service.dart';
import '../../domain/schedule_share_dto.dart';
import '../providers/sharing_provider.dart';
import 'course_selection_screen.dart';
import 'scan_qr_screen.dart';
import 'share_qr_screen.dart';

/// Entry screen for the sharing feature.
///
/// Offers two export modes:
/// - **Full Schedule** → encodes all courses + sessions → QR
/// - **Specific Courses** → navigates to course selection
class ExportModeScreen extends ConsumerWidget {
  const ExportModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('SHARE SCHEDULE')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXPORT MODE', style: AppTextStyles.sectionHeader(context)),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to share your schedule.',
              style: AppTextStyles.cardSubtitle(context),
            ),
            const SizedBox(height: 24),

            // ── Full Schedule Card ──────────────────────────────────────
            _ExportOptionCard(
              icon: Icons.calendar_month_rounded,
              title: 'Full Schedule',
              subtitle: 'Share all courses and sessions',
              onTap: () => _exportFull(context, ref),
            ),
            const SizedBox(height: 16),

            // ── Selective Export Card ────────────────────────────────────
            _ExportOptionCard(
              icon: Icons.checklist_rounded,
              title: 'Specific Courses',
              subtitle: 'Pick which courses to share',
              onTap: () {
                // Reset selection state before navigating
                ref.read(courseSelectionProvider.notifier).clearAll();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CourseSelectionScreen(),
                  ),
                );
              },
            ),

            const Spacer(),

            // ── Scan QR option ──────────────────────────────────────────
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: const Text('Scan a QR code instead'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _exportFull(BuildContext context, WidgetRef ref) async {
    final encoder = ref.read(shareEncoderProvider);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await encoder.encodeFull();

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
      Navigator.of(context).pop(); // dismiss loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to encode schedule: $e')));
    }
  }

  void _showSizeLimitDialog(BuildContext context, EncodeResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Schedule Too Large'),
        content: Text(
          'Your full schedule is ${result.byteSize} bytes, which exceeds '
          'the safe QR limit of $kQrMaxBytes bytes.\n\n'
          'Try sharing specific courses instead to reduce the size.',
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

/// A tappable card representing an export option.
class _ExportOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardSurface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mutedDark.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.skyBlue, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.tileTitle()),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.cardSubtitle(context)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.mutedText(context)),
            ],
          ),
        ),
      ),
    );
  }
}
