import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/share_decoder_service.dart';
import '../providers/sharing_provider.dart';
import 'share_preview_screen.dart';

/// Screen that uses the device camera to scan a QR code containing
/// a shared schedule payload.
class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({super.key});

  @override
  ConsumerState<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends ConsumerState<ScanQrScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SCAN QR')),
      body: Stack(
        children: [
          // ── Camera preview ──────────────────────────────────────────
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // ── Overlay ─────────────────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bgDark.withValues(alpha: 0.5),
                    AppColors.bgDark.withValues(alpha: 0.0),
                    AppColors.bgDark.withValues(alpha: 0.0),
                    AppColors.bgDark.withValues(alpha: 0.5),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // ── Instructions ────────────────────────────────────────────
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColors.skyBlue,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Point your camera at the QR code',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.tileTitle().copyWith(
                    color: AppColors.fgDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'The schedule will be detected automatically',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardSubtitle(
                    context,
                  ).copyWith(color: AppColors.fgDark.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    _hasScanned = true;
    _controller.stop();

    final payload = barcode.rawValue!;
    final decoder = ref.read(shareDecoderProvider);

    try {
      final dto = decoder.decode(payload);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SharePreviewScreen(dto: dto)),
      );
    } on ShareDecodeException catch (e) {
      if (!mounted) return;
      _hasScanned = false;
      _controller.start();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
