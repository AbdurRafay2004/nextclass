import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/course/data/models/course.dart';
import '../../features/schedule/data/models/class_session.dart';

final databaseProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Database must be overridden in main before use');
});

class DatabaseManager {
  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([
      CourseSchema,
      ClassSessionSchema,
    ], directory: dir.path);
    return isar;
  }
}
