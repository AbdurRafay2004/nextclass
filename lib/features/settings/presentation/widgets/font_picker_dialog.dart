import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

class FontPickerDialog extends ConsumerWidget {
  const FontPickerDialog({super.key});

  static const List<String> availableFonts = [
    'Bricolage Grotesque',
    'Manrope',
    'Amarante',
    'Federo',
    'Limelight',
    'Pompiere',
    'DM Serif Display',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFont = ref.watch(fontFamilyProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'App Font',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.mutedText(context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: availableFonts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final font = availableFonts[index];
                final isSelected = font == currentFont;

                return InkWell(
                  onTap: () {
                    ref.read(fontFamilyProvider.notifier).setFontFamily(font);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brandSkyBlue.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.brandSkyBlue
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            font,
                            style: GoogleFonts.getFont(font).copyWith(
                              fontSize: 18,
                              color: isSelected
                                  ? AppColors.brandSkyBlue
                                  : AppColors.fgDark,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.brandSkyBlue,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
