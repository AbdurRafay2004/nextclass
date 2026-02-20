import 'package:isar/isar.dart';

part 'class_session.g.dart';

enum SessionType { lecture, lab, tutorial }

@collection
class ClassSession {
  Id id = Isar.autoIncrement;

  late String courseUuid;

  /// 1 = Monday, 7 = Sunday
  late int dayOfWeek;

  /// Minutes since midnight (e.g., 600 = 10:00 AM)
  late int startTimeMinutes;

  late int durationMinutes;

  late String room;

  @enumerated
  late SessionType type;
}
