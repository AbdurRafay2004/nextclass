import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/time_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/time_utils.dart';
import '../providers/session_provider.dart';

class LiveStatusCard extends ConsumerWidget {
  final ScheduleItem item;

  const LiveStatusCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowAsync = ref.watch(timeProvider);
    final now = nowAsync.value ?? DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final endMinutes =
        item.session.startTimeMinutes + item.session.durationMinutes;

    final progress =
        (currentMinutes - item.session.startTimeMinutes) /
        item.session.durationMinutes;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final remainingMinutes = endMinutes - currentMinutes;

    final courseColor = AppColors.hexToColor(item.course.colorHex);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.mutedText(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface(context),
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color indicator
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                top: 12.0,
                bottom: 12.0,
              ),
              child: Container(
                width: 14,
                decoration: BoxDecoration(
                  color: courseColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOW tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.liveGreen,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        'NOW',
                        style: AppFonts.style(
                          color: AppColors.liveGreen,
                          fontWeight: FontWeight.w900,
                          fontSize: 8,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Course Code
                    Text(
                      item.course.code.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Course Name
                    Text(
                      item.course.name,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: onSurface,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Room and Faculty Info
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: muted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ROOM',
                                    style: AppTextStyles.labelUppercase(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.session.room,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: onSurface,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 14,
                                    color: muted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'FACULTY ACRONYM',
                                    style: AppTextStyles.labelUppercase(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.course.facultyAcronym,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: onSurface,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Divider
                    Divider(
                      color: AppColors.dividerColor(context),
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 12),
                    // Time Remaining and Ends At
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TIME REMAINING',
                              style: AppTextStyles.labelUppercase(context),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${remainingMinutes > 0 ? remainingMinutes : 0}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        color: onSurface,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'min',
                                  style: AppFonts.style(
                                    color: muted,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'ENDS AT',
                              style: AppTextStyles.labelUppercase(context),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatTime(endMinutes),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    LinearProgressIndicator(
                      value: clampedProgress,
                      backgroundColor: AppColors.dividerColor(context),
                      valueColor: AlwaysStoppedAnimation<Color>(onSurface),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
