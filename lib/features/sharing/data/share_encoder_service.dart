import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';

import '../../course/data/models/course.dart';
import '../../schedule/data/models/class_session.dart';
import '../domain/schedule_share_dto.dart';

/// Export mode for schedule sharing.
enum ExportMode { full, selected }

/// Result of an encoding operation.
class EncodeResult {
  /// The Base64-encoded, GZIP-compressed payload.
  final String payload;

  /// Raw byte count of the payload string (UTF-8).
  final int byteSize;

  /// Whether the payload exceeds the safe QR threshold.
  bool get exceedsQrLimit => byteSize > kQrMaxBytes;

  /// Human-readable size label.
  String get sizeLabel {
    if (byteSize < 800) return 'Small';
    if (byteSize < 1600) return 'Medium';
    return 'Large';
  }

  EncodeResult({required this.payload, required this.byteSize});
}

/// Service responsible for encoding schedule data into a QR-safe payload.
///
/// Pipeline: Isar models → DTO → JSON → GZIP → Base64
class ShareEncoderService {
  final Isar isar;

  ShareEncoderService({required this.isar});

  /// Encodes the full schedule (all courses + all sessions).
  Future<EncodeResult> encodeFull() async {
    final courses = await isar.courses.where().findAll();
    return _encodeForCourses(courses);
  }

  /// Encodes only the selected courses and their sessions.
  Future<EncodeResult> encodeSelected(List<String> courseUuids) async {
    final courses = <Course>[];
    for (final uuid in courseUuids) {
      final course = await isar.courses.filter().uuidEqualTo(uuid).findFirst();
      if (course != null) courses.add(course);
    }
    return _encodeForCourses(courses);
  }

  /// Estimates the encoded byte size for a set of course UUIDs without
  /// producing the full payload. Useful for the live size indicator.
  Future<int> estimateSize(List<String> courseUuids) async {
    final result = await encodeSelected(courseUuids);
    return result.byteSize;
  }

  /// Estimates the encoded byte size for the full schedule.
  Future<int> estimateFullSize() async {
    final result = await encodeFull();
    return result.byteSize;
  }

  // ── Internal ──────────────────────────────────────────────────────────

  Future<EncodeResult> _encodeForCourses(List<Course> courses) async {
    final sharedCourses = <SharedCourse>[];

    for (final course in courses) {
      final sessions = await isar.classSessions
          .filter()
          .courseUuidEqualTo(course.uuid)
          .findAll();
      sharedCourses.add(SharedCourse.fromModels(course, sessions));
    }

    final dto = ScheduleShareDTO(
      version: kShareDtoVersion,
      courses: sharedCourses,
    );

    // JSON → GZIP → Base64
    final jsonString = jsonEncode(dto.toJson());
    final jsonBytes = utf8.encode(jsonString);
    final gzipped = gzip.encode(jsonBytes);
    final base64Payload = base64Encode(gzipped);

    return EncodeResult(
      payload: base64Payload,
      byteSize: utf8.encode(base64Payload).length,
    );
  }
}
