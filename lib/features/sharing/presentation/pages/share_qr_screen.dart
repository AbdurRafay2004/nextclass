import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/share_encoder_service.dart';

/// Displays the generated QR code for the encoded schedule payload.
///
/// The receiver scans this QR to import the shared schedule.
class ShareQrScreen extends StatelessWidget {
  final EncodeResult encodeResult;

  const ShareQrScreen({super.key, required this.encodeResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SHARE QR')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SCAN TO IMPORT',
                style: AppTextStyles.sectionHeader(context),
              ),
              const SizedBox(height: 8),
              Text(
                'Ask your classmate to scan this QR code\nto import the schedule.',
                textAlign: TextAlign.center,
                style: AppTextStyles.cardSubtitle(context),
              ),
              const SizedBox(height: 32),

              // ── QR Code ───────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(AppColors.cardRadius),
                ),
                child: QrImageView(
                  data: encodeResult.payload,
                  version: QrVersions.auto,
                  size: 260,
                  backgroundColor: AppColors.bgLight,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
              const SizedBox(height: 24),

              // ── Size info ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface(context),
                  borderRadius: BorderRadius.circular(AppColors.formRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.data_usage_rounded,
                      size: 16,
                      color: _sizeColor(encodeResult.byteSize),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${encodeResult.sizeLabel} • ${encodeResult.byteSize} bytes',
                      style: AppTextStyles.cardSubtitle(
                        context,
                      ).copyWith(color: _sizeColor(encodeResult.byteSize)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ── Done button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Pop back to the export mode screen (or wherever we came from)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderDark),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppColors.formRadius),
                    ),
                  ),
                  child: Text('Done', style: AppTextStyles.actionButton()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _sizeColor(int bytes) {
    if (bytes < 800) return AppColors.liveGreen;
    if (bytes < 1600) return AppColors.butterYellow;
    return AppColors.coralRose;
  }
}
