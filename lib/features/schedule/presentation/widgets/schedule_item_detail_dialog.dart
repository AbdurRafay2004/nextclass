import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/time_utils.dart';
import '../providers/session_provider.dart';

class ScheduleItemDetailDialog extends StatelessWidget {
  final ScheduleItem item;

  const ScheduleItemDetailDialog({super.key, required this.item});

  String _dayOfWeekToString(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[day - 1];
  }

  @override
  Widget build(BuildContext context) {
    final courseColor = AppColors.hexToColor(item.course.colorHex);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.mutedText(context);

    // Calculate end time and duration
    final startTime = formatTime(item.session.startTimeMinutes);
    final endTime = formatTime(
      item.session.startTimeMinutes + item.session.durationMinutes,
    );
    final durationHours = item.session.durationMinutes ~/ 60;
    final durationMinutes = item.session.durationMinutes % 60;

    String durationLabel = '';
    if (durationHours > 0) durationLabel += '$durationHours hr ';
    if (durationMinutes > 0) durationLabel += '$durationMinutes min';
    durationLabel = durationLabel.trim();

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
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Class Details',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: muted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Course Info Top Section
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: courseColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: courseColor, width: 2),
                        ),
                        child: Icon(Icons.class_, color: courseColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.course.code.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: courseColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.course.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Detail Rows
                  _buildDetailRow(
                    context,
                    icon: Icons.person_outline,
                    color: AppColors.skyBlue,
                    label: 'Faculty Acronym',
                    value: item.course.facultyAcronym,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    context,
                    icon: Icons.location_on_outlined,
                    color: AppColors.apricotGlow,
                    label: 'Room',
                    value: item.session.room,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    context,
                    icon: Icons.category_outlined,
                    color: AppColors.lavenderMist,
                    label: 'Session Type',
                    value: item.session.type.name.toUpperCase(),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    color: AppColors.mintGreen,
                    label: 'Day',
                    value: _dayOfWeekToString(item.session.dayOfWeek),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    context,
                    icon: Icons.access_time,
                    color: AppColors.blushPink,
                    label: 'Time',
                    value: '$startTime — $endTime',
                    subValue: '($durationLabel)',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    String? subValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelUppercase(context)),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (subValue != null)
                    Text(
                      subValue,
                      style: AppTextStyles.unitSuffix(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
