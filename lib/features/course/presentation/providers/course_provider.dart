import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_manager.dart';
import '../../../../core/database/database_write_serializer.dart';
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
  final DatabaseWriteSerializer _serializer;

  CourseController({
    required this.isar,
    required DatabaseWriteSerializer serializer,
  }) : _serializer = serializer;

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

    await _serializer.safeWrite(() async {
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

    await _serializer.safeWrite(() async {
      await isar.writeTxn(() async {
        await isar.courses.put(course);
      });
    });
  }

  Future<void> deleteCourse(String uuid) async {
    // Read outside the write transaction to minimize lock hold time
    final course = await isar.courses.filter().uuidEqualTo(uuid).findFirst();
    if (course == null) return;

    final sessionIds = await isar.classSessions
        .filter()
        .courseUuidEqualTo(uuid)
        .idProperty()
        .findAll();

    await _serializer.safeWrite(() async {
      await isar.writeTxn(() async {
        await isar.courses.delete(course.id);
        await isar.classSessions.deleteAll(sessionIds);
      });
    });
  }
}

// Provider for the controller
final courseControllerProvider = Provider<CourseController>((ref) {
  final isar = ref.watch(databaseProvider);
  final serializer = ref.watch(databaseWriteSerializerProvider);
  return CourseController(isar: isar, serializer: serializer);
});
