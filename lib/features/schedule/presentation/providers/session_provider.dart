import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database_manager.dart';
import '../../../../core/providers/time_provider.dart';
import '../../../course/data/models/course.dart';
import '../../data/models/class_session.dart';

// Represents a combined entity of Session + Course Details
class ScheduleItem {
  final ClassSession session;
  final Course course;

  ScheduleItem({required this.session, required this.course});
}

// Provider for getting today's day of week (1..7).
// Derives from timeProvider so it reactively updates past midnight.
final currentDayProvider = Provider<int>((ref) {
  final now = ref.watch(timeProvider).value ?? DateTime.now();
  return now.weekday;
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
      final sessions = await isar.classSessions
          .filter()
          .courseUuidEqualTo(courseUuid)
          .findAll();

      // Custom sort: Saturday(6) first, then Sunday(7), then Mon(1)...
      // (day + 1) % 7 maps: 6->0, 7->1, 1->2, 2->3, 3->4, 4->5, 5->6
      sessions.sort((a, b) {
        final aDaySorted = (a.dayOfWeek + 1) % 7;
        final bDaySorted = (b.dayOfWeek + 1) % 7;
        if (aDaySorted != bDaySorted) {
          return aDaySorted.compareTo(bDaySorted);
        }
        return a.startTimeMinutes.compareTo(b.startTimeMinutes);
      });

      return sessions;
    });

// A computed provider that yields the current live class and upcoming classes
// based on the realtime clock.
typedef DashboardSchedule = ({
  ScheduleItem? liveItem,
  List<ScheduleItem> upcomingItems,
});

final dashboardScheduleProvider = Provider<AsyncValue<DashboardSchedule>>((
  ref,
) {
  final currentDay = ref.watch(currentDayProvider);
  final scheduleAsync = ref.watch(dayScheduleProvider(currentDay));
  final nowAsync = ref.watch(timeProvider);

  if (scheduleAsync.isLoading || nowAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (scheduleAsync.hasError) {
    return AsyncValue.error(scheduleAsync.error!, scheduleAsync.stackTrace!);
  }

  final items = scheduleAsync.value ?? [];
  final now = nowAsync.value ?? DateTime.now();
  final currentMinutes = now.hour * 60 + now.minute;

  ScheduleItem? liveItem;
  for (var item in items) {
    final endMinutes =
        item.session.startTimeMinutes + item.session.durationMinutes;
    if (currentMinutes >= item.session.startTimeMinutes &&
        currentMinutes <= endMinutes) {
      liveItem = item;
      break;
    }
  }

  final upcomingItems = items.where((i) {
    if (i == liveItem) return false;
    final endMinutes = i.session.startTimeMinutes + i.session.durationMinutes;
    return currentMinutes < endMinutes;
  }).toList();

  return AsyncValue.data((liveItem: liveItem, upcomingItems: upcomingItems));
});
