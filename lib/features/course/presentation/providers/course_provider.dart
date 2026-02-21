import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_manager.dart';
import '../../data/models/course.dart';
import '../../../schedule/data/models/class_session.dart';

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

  Future<void> addCourse({
    required String name,
    required String code,
    required String colorHex,
    required String facultyAcronym,
  }) async {
    final course = Course()
      ..uuid = const Uuid().v4()
      ..name = name
      ..code = code
      ..colorHex = colorHex
      ..facultyAcronym = facultyAcronym;

    await isar.writeTxn(() async {
      await isar.courses.put(course);
    });
  }

  Future<void> updateCourse(Course course) async {
    await isar.writeTxn(() async {
      await isar.courses.put(course);
    });
  }

  Future<void> deleteCourse(String uuid) async {
    await isar.writeTxn(() async {
      // Find the course id
      final course = await isar.courses.filter().uuidEqualTo(uuid).findFirst();
      if (course != null) {
        await isar.courses.delete(course.id);

        // Cascade delete all sessions tied to this course
        await isar.classSessions.filter().courseUuidEqualTo(uuid).deleteAll();
      }
    });
  }
}

// Provider for the controller
final courseControllerProvider = Provider<CourseController>((ref) {
  final isar = ref.watch(databaseProvider);
  return CourseController(isar: isar);
});
