import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../schedule/data/models/class_session.dart';
import '../../../schedule/presentation/pages/session_add_page.dart';
import '../../../schedule/presentation/providers/session_provider.dart';
import '../../data/models/course.dart';
import '../providers/course_provider.dart';
import 'course_add_page.dart';

class CourseDetailPage extends ConsumerWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

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

  void _showSessionOptionsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ClassSession session,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppColors.cardRadius),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SessionAddPage(
                        course: course,
                        sessionToEdit: session,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SessionAddPage(
                        course: course,
                        sessionToDuplicate: session,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Delete',
                  style: AppTextStyles.destructiveAction(context),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showDeleteConfirmationDialog(context, ref, session);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    ClassSession session,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Session'),
          content: const Text('Are you sure you want to delete this session?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(sessionControllerProvider)
                    .deleteSession(session.id);
                if (context.mounted) {
                  ref.invalidate(sessionsByCourseProvider(course.uuid));
                  ref.invalidate(dayScheduleProvider);
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session deleted')),
                  );
                }
              },
              child: Text(
                'Delete',
                style: AppTextStyles.destructiveAction(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCourseDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: const Text(
            'Are you sure you want to delete this course and all its sessions?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(courseControllerProvider)
                    .deleteCourse(course.uuid);
                if (context.mounted) {
                  ref.invalidate(coursesProvider);
                  ref.invalidate(dayScheduleProvider);
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course deleted')),
                  );
                }
              },
              child: Text(
                'Delete',
                style: AppTextStyles.destructiveAction(context),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsByCourseProvider(course.uuid));
    final courseAsync = ref.watch(courseByUuidProvider(course.uuid));
    final displayCourse = courseAsync.value ?? course;

    final courseColor = AppColors.hexToColor(displayCourse.colorHex);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.mutedText(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(displayCourse.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseAddPage(courseToEdit: displayCourse),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              _showCourseDeleteConfirmationDialog(context, ref);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section — redesigned as a card with left color pill
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardSurface(context),
                borderRadius: BorderRadius.circular(AppColors.cardRadius),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left color pill
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayCourse.code.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: courseColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              displayCourse.name,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: muted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  displayCourse.facultyAcronym,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: muted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Theme Color',
                                  style: AppTextStyles.infoLabel(context),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: courseColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sessions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLASS SESSIONS',
                    style: AppTextStyles.sectionHeader(context),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SessionAddPage(course: displayCourse),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No sessions added yet.',
                      style: AppTextStyles.cardSubtitle(context),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface(context),
                        borderRadius: BorderRadius.circular(
                          AppColors.cardRadius,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        title: Text(
                          _dayOfWeekToString(session.dayOfWeek),
                          style: AppTextStyles.sessionDayTitle(context),
                        ),
                        subtitle: Text(
                          '${formatTime(session.startTimeMinutes)} - ${formatTime(session.startTimeMinutes + session.durationMinutes)}\nRoom: ${session.room} · ${session.type.name.toUpperCase()}',
                          style: AppTextStyles.sessionDetail(context),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert, color: muted),
                          onPressed: () {
                            _showSessionOptionsBottomSheet(
                              context,
                              ref,
                              session,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }
}
