import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_manager.dart';
import '../../../schedule/data/models/class_session.dart';
import '../../data/models/course.dart';

// Stream of all courses to keep the list reactively updated
final coursesProvider = StreamProvider<List<Course>>((ref) {
  final isar = ref.watch(databaseProvider);
  return isar.courses.where().watch(fireImmediately: true);
});

// A FutureProvider used to fetch a single course by its UUID
final courseByUuidProvider = FutureProvider.family<Course?, String>((
  ref,
  uuid,
) async {
  final isar = ref.watch(databaseProvider);
  return isar.courses.filter().uuidEqualTo(uuid).findFirst();
});

// A Controller to handle Course mutations
class CourseController {
  final Isar isar;
  CourseController({required this.isar});

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    const maxRetries = 3;
    const baseDelay = Duration(milliseconds: 50);

    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        if (e is IsarError &&
            (e.toString().contains('11') ||
                e.toString().contains('Try again'))) {
          if (attempt == maxRetries) rethrow;
          await Future.delayed(baseDelay * attempt);
        } else {
          rethrow;
        }
      }
    }
    throw StateError('Unreachable retry state');
  }

  Future<Course> addCourse({
    required String name,
    required String code,
    required String colorHex,
    required String facultyAcronym,
    String? facultyFullName,
    String? facultyEmail,
    String? facultyPhone,
    String? facultyDepartment,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Course name cannot be empty.');
    }
    if (code.trim().isEmpty) {
      throw ArgumentError('Course code cannot be empty.');
    }
    if (colorHex.trim().isEmpty) {
      throw ArgumentError('Course color cannot be empty.');
    }
    if (facultyAcronym.trim().isEmpty) {
      throw ArgumentError('Faculty acronym cannot be empty.');
    }

    final course = Course()
      ..uuid = const Uuid().v4()
      ..name = name
      ..code = code
      ..colorHex = colorHex
      ..facultyAcronym = facultyAcronym
      ..facultyFullName = facultyFullName
      ..facultyEmail = facultyEmail
      ..facultyPhone = facultyPhone
      ..facultyDepartment = facultyDepartment;

    await _withRetry(() async {
      await isar.writeTxn(() async {
        await isar.courses.put(course);
      });
    });

    return course;
  }

  Future<void> updateCourse({
    required int id,
    required String uuid,
    required String name,
    required String code,
    required String colorHex,
    required String facultyAcronym,
    String? facultyFullName,
    String? facultyEmail,
    String? facultyPhone,
    String? facultyDepartment,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Course name cannot be empty.');
    }
    if (code.trim().isEmpty) {
      throw ArgumentError('Course code cannot be empty.');
    }
    if (colorHex.trim().isEmpty) {
      throw ArgumentError('Course color cannot be empty.');
    }
    if (facultyAcronym.trim().isEmpty) {
      throw ArgumentError('Faculty acronym cannot be empty.');
    }

    final course = Course()
      ..id = id
      ..uuid = uuid
      ..name = name
      ..code = code
      ..colorHex = colorHex
      ..facultyAcronym = facultyAcronym
      ..facultyFullName = facultyFullName
      ..facultyEmail = facultyEmail
      ..facultyPhone = facultyPhone
      ..facultyDepartment = facultyDepartment;

    await _withRetry(() async {
      await isar.writeTxn(() async {
        await isar.courses.put(course);
      });
    });
  }

  Future<void> deleteCourse(String uuid) async {
    await _withRetry(() async {
      await isar.writeTxn(() async {
        // Find the course id
        final course = await isar.courses
            .filter()
            .uuidEqualTo(uuid)
            .findFirst();
        if (course != null) {
          await isar.courses.delete(course.id);

          // Cascade delete all sessions tied to this course
          await isar.classSessions.filter().courseUuidEqualTo(uuid).deleteAll();
        }
      });
    });
  }
}

// Provider for the controller
final courseControllerProvider = Provider<CourseController>((ref) {
  final isar = ref.watch(databaseProvider);
  return CourseController(isar: isar);
});
