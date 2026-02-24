/// Data Transfer Object for schedule sharing via QR code.
///
/// Uses short keys to minimize payload size for QR encoding:
/// - `v`  → version
/// - `cs` → courses list
/// - `n`  → course name
/// - `c`  → course code
/// - `ch` → color hex
/// - `fa` → faculty acronym
/// - `fn` → faculty full name (optional)
/// - `fe` → faculty email (optional)
/// - `fp` → faculty phone (optional)
/// - `fd` → faculty department (optional)
/// - `ss` → sessions list
/// - `d`  → day of week
/// - `st` → start time (minutes)
/// - `du` → duration (minutes)
/// - `r`  → room
/// - `t`  → session type index
library;

import '../../course/data/models/course.dart';
import '../../schedule/data/models/class_session.dart';

/// Current DTO version for forward compatibility.
const int kShareDtoVersion = 1;

/// Maximum safe QR byte threshold (bytes after Base64 encoding).
const int kQrMaxBytes = 2500;

/// Represents a shareable schedule payload.
class ScheduleShareDTO {
  final int version;
  final List<SharedCourse> courses;

  ScheduleShareDTO({required this.version, required this.courses});

  /// Deserializes from a short-key JSON map.
  factory ScheduleShareDTO.fromJson(Map<String, dynamic> json) {
    return ScheduleShareDTO(
      version: json['v'] as int? ?? kShareDtoVersion,
      courses: (json['cs'] as List<dynamic>)
          .map((e) => SharedCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Serializes to a short-key JSON map.
  Map<String, dynamic> toJson() => {
    'v': version,
    'cs': courses.map((c) => c.toJson()).toList(),
  };
}

/// A course with its sessions, ready for sharing.
class SharedCourse {
  final String name;
  final String code;
  final String colorHex;
  final String facultyAcronym;
  final String? facultyFullName;
  final String? facultyEmail;
  final String? facultyPhone;
  final String? facultyDepartment;
  final List<SharedSession> sessions;

  SharedCourse({
    required this.name,
    required this.code,
    required this.colorHex,
    required this.facultyAcronym,
    this.facultyFullName,
    this.facultyEmail,
    this.facultyPhone,
    this.facultyDepartment,
    required this.sessions,
  });

  /// Creates a [SharedCourse] from a [Course] model and its [ClassSession]s.
  factory SharedCourse.fromModels(Course course, List<ClassSession> sessions) {
    return SharedCourse(
      name: course.name,
      code: course.code,
      colorHex: course.colorHex,
      facultyAcronym: course.facultyAcronym,
      facultyFullName: course.facultyFullName,
      facultyEmail: course.facultyEmail,
      facultyPhone: course.facultyPhone,
      facultyDepartment: course.facultyDepartment,
      sessions: sessions.map(SharedSession.fromModel).toList(),
    );
  }

  factory SharedCourse.fromJson(Map<String, dynamic> json) {
    return SharedCourse(
      name: json['n'] as String,
      code: json['c'] as String,
      colorHex: json['ch'] as String,
      facultyAcronym: json['fa'] as String,
      facultyFullName: json['fn'] as String?,
      facultyEmail: json['fe'] as String?,
      facultyPhone: json['fp'] as String?,
      facultyDepartment: json['fd'] as String?,
      sessions:
          (json['ss'] as List<dynamic>?)
              ?.map((e) => SharedSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Serializes to short-key JSON, omitting null optional fields.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'n': name,
      'c': code,
      'ch': colorHex,
      'fa': facultyAcronym,
      'ss': sessions.map((s) => s.toJson()).toList(),
    };
    if (facultyFullName != null) map['fn'] = facultyFullName;
    if (facultyEmail != null) map['fe'] = facultyEmail;
    if (facultyPhone != null) map['fp'] = facultyPhone;
    if (facultyDepartment != null) map['fd'] = facultyDepartment;
    return map;
  }
}

/// A single session, ready for sharing.
class SharedSession {
  final int dayOfWeek;
  final int startTimeMinutes;
  final int durationMinutes;
  final String room;
  final int typeIndex; // SessionType.index

  SharedSession({
    required this.dayOfWeek,
    required this.startTimeMinutes,
    required this.durationMinutes,
    required this.room,
    required this.typeIndex,
  });

  /// Creates a [SharedSession] from a [ClassSession] model.
  factory SharedSession.fromModel(ClassSession session) {
    return SharedSession(
      dayOfWeek: session.dayOfWeek,
      startTimeMinutes: session.startTimeMinutes,
      durationMinutes: session.durationMinutes,
      room: session.room,
      typeIndex: session.type.index,
    );
  }

  factory SharedSession.fromJson(Map<String, dynamic> json) {
    return SharedSession(
      dayOfWeek: json['d'] as int,
      startTimeMinutes: json['st'] as int,
      durationMinutes: json['du'] as int,
      room: json['r'] as String,
      typeIndex: json['t'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'd': dayOfWeek,
    'st': startTimeMinutes,
    'du': durationMinutes,
    'r': room,
    't': typeIndex,
  };
}
