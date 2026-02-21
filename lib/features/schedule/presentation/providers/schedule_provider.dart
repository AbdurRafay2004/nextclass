import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database_manager.dart';
import '../../../course/data/models/course.dart';
import '../../data/models/class_session.dart';

// Represents a combined entity of Session + Course Details
class ScheduleItem {
  final ClassSession session;
  final Course course;

  ScheduleItem({required this.session, required this.course});
}

// Provider for getting today's day of week (1..7)
final currentDayProvider = Provider<int>((ref) {
  return DateTime.now().weekday;
});

// An isolated auto-updating clock stream that yields the current time immediately,
// and then updates every minute, synchronized with the system clock rollover.
final timeProvider = StreamProvider<DateTime>((ref) async* {
  // Yield initial time immediately
  yield DateTime.now();

  // Calculate delay until the next minute rollover
  final now = DateTime.now();
  final delay = 60 - now.second;

  // Wait for the next minute to start
  await Future.delayed(Duration(seconds: delay));

  // Yield the synchronized time
  yield DateTime.now();

  // Thereafter, update every minute
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

// Fetches the schedule for a given day (1..7)
final dayScheduleProvider = FutureProvider.family<List<ScheduleItem>, int>((
  ref,
  day,
) async {
  final isar = ref.watch(databaseProvider);

  // Find sessions for this day, sorted by start time
  final sessions = await isar.classSessions
      .filter()
      .dayOfWeekEqualTo(day)
      .sortByStartTimeMinutes()
      .findAll();

  // For each session, fetch the associated course
  final List<ScheduleItem> scheduleItems = [];
  for (var session in sessions) {
    final course = await isar.courses
        .filter()
        .uuidEqualTo(session.courseUuid)
        .findFirst();
    if (course != null) {
      scheduleItems.add(ScheduleItem(session: session, course: course));
    }
  }

  return scheduleItems;
});

// Fetches all sessions assigned to a specific Course UUID
final sessionsByCourseProvider =
    FutureProvider.family<List<ClassSession>, String>((ref, courseUuid) async {
      final isar = ref.watch(databaseProvider);
      return isar.classSessions
          .filter()
          .courseUuidEqualTo(courseUuid)
          .sortByDayOfWeek()
          .thenByStartTimeMinutes()
          .findAll();
    });
