import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/database_error_widget.dart';
import '../providers/course_provider.dart';
import 'course_add_page.dart';
import 'course_detail_page.dart';

class CourseListPage extends ConsumerWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.mutedText(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('COURSES'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CourseAddPage()),
              );
            },
          ),
        ],
      ),
      body: coursesAsync.when(
        data: (courses) {
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 64, color: muted),
                  const SizedBox(height: 16),
                  Text(
                    'No Courses Yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first course.',
                    style: AppTextStyles.cardSubtitle(context),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final course = courses[index];
              final courseColor = AppColors.hexToColor(course.colorHex);

              return Dismissible(
                key: Key(course.uuid),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(AppColors.cardRadius),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                          'Are you sure you wish to delete this course and all its sessions?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'DELETE',
                              style: AppTextStyles.destructiveAction(context),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  ref.read(courseControllerProvider).deleteCourse(course.uuid);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${course.name} deleted')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface(context),
                    borderRadius: BorderRadius.circular(AppColors.cardRadius),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppColors.cardRadius),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailPage(course: course),
                          ),
                        );
                      },
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
                            // Content
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
                                      course.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: onSurface,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      course.code,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
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
                                            course.facultyAcronym,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(color: muted),
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
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: muted,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => DatabaseErrorWidget(
          error: err,
          onRetry: () => ref.invalidate(coursesProvider),
        ),
      ),
    );
  }
}
