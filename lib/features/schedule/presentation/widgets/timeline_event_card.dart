import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_utils.dart';
import '../providers/session_provider.dart';

class TimelineEventCard extends StatelessWidget {
  final ScheduleItem item;

  const TimelineEventCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final courseColor = AppColors.hexToColor(item.course.colorHex);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.mutedText(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface(context),
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color strip (inset and rounded)
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

            // Time Column
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 16,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatTimeOnly(item.session.startTimeMinutes),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    formatAmPm(item.session.startTimeMinutes),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: muted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, size: 14, color: courseColor),
                      const SizedBox(width: 4),
                      Text(
                        item.session.room.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Vertical Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Container(
                width: 1,
                color: AppColors.dividerColor(context),
              ),
            ),

            // Subject Details Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.course.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.course.code,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: courseColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: courseColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.course.facultyAcronym,
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(color: muted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Trailing Icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Icon(Icons.edit_note_rounded, color: muted, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
