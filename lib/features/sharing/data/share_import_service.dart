import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database_write_serializer.dart';

import '../../course/data/models/course.dart';
import '../../schedule/data/models/class_session.dart';
import '../domain/schedule_share_dto.dart';

/// How to handle conflicts when importing shared data.
enum ImportMode {
  /// Replace existing courses that match by code, and add new ones.
  replace,

  /// Merge sessions into existing courses (add missing, skip duplicates).
  merge,
}

/// Summary returned after an import operation.
class ImportResult {
  final int coursesAdded;
  final int coursesUpdated;
  final int sessionsAdded;
  final int sessionsSkipped;

  ImportResult({
    required this.coursesAdded,
    required this.coursesUpdated,
    required this.sessionsAdded,
    required this.sessionsSkipped,
  });
}

/// Service responsible for importing a decoded [ScheduleShareDTO] into the
/// local Isar database.
///
/// Conflict scope: only imported courses are checked — existing courses
/// not in the import payload are never touched.
class ShareImportService {
  final Isar isar;
  final DatabaseWriteSerializer _serializer;

  ShareImportService({
    required this.isar,
    required DatabaseWriteSerializer serializer,
  }) : _serializer = serializer;

  /// Imports the given [dto] using the specified [mode].
  Future<ImportResult> import(
    ScheduleShareDTO dto, {
    required ImportMode mode,
  }) async {
    int coursesAdded = 0;
    int coursesUpdated = 0;
    int sessionsAdded = 0;
    int sessionsSkipped = 0;

    final incomingCodes = dto.courses
        .where((c) => c.name.trim().isNotEmpty && c.code.trim().isNotEmpty)
        .map((c) => c.code)
        .toList();

    // 1. Pre-fetch existing courses
    final matchedCourses = incomingCodes.isEmpty 
        ? <Course>[]
        : await isar.courses
            .filter()
            .anyOf(incomingCodes, (q, code) => q.codeEqualTo(code))
            .findAll();

    final existingCoursesMap = {for (final c in matchedCourses) c.code: c};

    // 2. Pre-fetch existing sessions for matched courses
    final Map<String, List<int>> existingSessionIdsMap = {};
    final Map<String, List<ClassSession>> existingSessionsMap = {};

    if (existingCoursesMap.isNotEmpty) {
      final existingUuids = existingCoursesMap.values.map((c) => c.uuid).toList();
      
      final allExistingSessions = await isar.classSessions
          .filter()
          .anyOf(existingUuids, (q, uuid) => q.courseUuidEqualTo(uuid))
          .findAll();

      for (final session in allExistingSessions) {
        existingSessionIdsMap.putIfAbsent(session.courseUuid, () => []).add(session.id);
        existingSessionsMap.putIfAbsent(session.courseUuid, () => []).add(session);
      }
    }

    await _serializer.safeWrite(() async {
      await isar.writeTxn(() async {
        for (final sharedCourse in dto.courses) {
          if (sharedCourse.name.trim().isEmpty || sharedCourse.code.trim().isEmpty) {
            continue; // Skip invalid courses
          }

          // Lookup pre-fetched course
          final existingCourse = existingCoursesMap[sharedCourse.code];
          String courseUuid;

          if (existingCourse != null) {
            courseUuid = existingCourse.uuid;

            if (mode == ImportMode.replace) {
              // Update the existing course with imported data
              final updated = Course()
                ..id = existingCourse.id
                ..uuid = existingCourse.uuid
                ..name = sharedCourse.name
                ..code = sharedCourse.code
                ..colorHex = sharedCourse.colorHex
                ..facultyAcronym = sharedCourse.facultyAcronym
                ..facultyFullName = sharedCourse.facultyFullName
                ..facultyEmail = sharedCourse.facultyEmail
                ..facultyPhone = sharedCourse.facultyPhone
                ..facultyDepartment = sharedCourse.facultyDepartment;

              await isar.courses.put(updated);

              // Delete all existing sessions using pre-fetched IDs
              final idsToDelete = existingSessionIdsMap[courseUuid] ?? [];
              if (idsToDelete.isNotEmpty) {
                await isar.classSessions.deleteAll(idsToDelete);
              }

              coursesUpdated++;
            } else {
              // Merge mode: keep existing course data, only add missing sessions
              coursesUpdated++;
            }
          } else {
            // New course — create it
            courseUuid = const Uuid().v4();
            final newCourse = Course()
              ..uuid = courseUuid
              ..name = sharedCourse.name
              ..code = sharedCourse.code
              ..colorHex = sharedCourse.colorHex
              ..facultyAcronym = sharedCourse.facultyAcronym
              ..facultyFullName = sharedCourse.facultyFullName
              ..facultyEmail = sharedCourse.facultyEmail
              ..facultyPhone = sharedCourse.facultyPhone
              ..facultyDepartment = sharedCourse.facultyDepartment;

            await isar.courses.put(newCourse);
            coursesAdded++;
          }

          // Import sessions
          if (mode == ImportMode.replace || existingCourse == null) {
            // Replace mode or new course: add all sessions directly
            for (final sharedSession in sharedCourse.sessions) {
              final session = ClassSession()
                ..courseUuid = courseUuid
                ..dayOfWeek = sharedSession.dayOfWeek
                ..startTimeMinutes = sharedSession.startTimeMinutes
                ..durationMinutes = sharedSession.durationMinutes
                ..room = sharedSession.room
                ..type = SessionType.values[sharedSession.typeIndex];

              await isar.classSessions.put(session);
              sessionsAdded++;
            }
          } else {
            // Merge mode with existing course: only add sessions that don't exist
            // Use pre-fetched sessions
            final existingSessions = existingSessionsMap[courseUuid] ?? [];

            for (final sharedSession in sharedCourse.sessions) {
              final isDuplicate = existingSessions.any(
                (existing) =>
                    existing.dayOfWeek == sharedSession.dayOfWeek &&
                    existing.startTimeMinutes ==
                        sharedSession.startTimeMinutes &&
                    existing.durationMinutes == sharedSession.durationMinutes &&
                    existing.room == sharedSession.room &&
                    existing.type.index == sharedSession.typeIndex,
              );

              if (isDuplicate) {
                sessionsSkipped++;
              } else {
                final session = ClassSession()
                  ..courseUuid = courseUuid
                  ..dayOfWeek = sharedSession.dayOfWeek
                  ..startTimeMinutes = sharedSession.startTimeMinutes
                  ..durationMinutes = sharedSession.durationMinutes
                  ..room = sharedSession.room
                  ..type = SessionType.values[sharedSession.typeIndex];

                await isar.classSessions.put(session);
                sessionsAdded++;
              }
            }
          }
        }
      });
    });

    return ImportResult(
      coursesAdded: coursesAdded,
      coursesUpdated: coursesUpdated,
      sessionsAdded: sessionsAdded,
      sessionsSkipped: sessionsSkipped,
    );
  }
}
