import 'package:isar/isar.dart';

part 'course.g.dart';

@collection
class Course {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String name;
  late String code;
  late String colorHex;
  late String facultyAcronym;
}
