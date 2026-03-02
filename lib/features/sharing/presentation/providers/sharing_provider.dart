import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_manager.dart';
import '../../../../core/database/database_write_serializer.dart';
import '../../data/share_decoder_service.dart';
import '../../data/share_encoder_service.dart';
import '../../data/share_import_service.dart';

/// Provider for the [ShareEncoderService].
final shareEncoderProvider = Provider<ShareEncoderService>((ref) {
  final isar = ref.watch(databaseProvider);
  return ShareEncoderService(isar: isar);
});

/// Provider for the [ShareDecoderService].
final shareDecoderProvider = Provider<ShareDecoderService>((ref) {
  return ShareDecoderService();
});

/// Provider for the [ShareImportService].
final shareImportProvider = Provider<ShareImportService>((ref) {
  final isar = ref.watch(databaseProvider);
  final serializer = ref.watch(databaseWriteSerializerProvider);
  return ShareImportService(isar: isar, serializer: serializer);
});

/// Tracks which course UUIDs are selected for selective export.
class CourseSelectionNotifier extends StateNotifier<Set<String>> {
  CourseSelectionNotifier() : super({});

  void toggle(String uuid) {
    if (state.contains(uuid)) {
      state = {...state}..remove(uuid);
    } else {
      state = {...state, uuid};
    }
  }

  void selectAll(List<String> uuids) {
    state = uuids.toSet();
  }

  void clearAll() {
    state = {};
  }

  bool get hasSelection => state.isNotEmpty;
}

final courseSelectionProvider =
    StateNotifierProvider<CourseSelectionNotifier, Set<String>>((ref) {
      return CourseSelectionNotifier();
    });

/// Provides a live byte-size estimate for the currently selected courses.
final estimatedSizeProvider = FutureProvider<int>((ref) async {
  final selectedUuids = ref.watch(courseSelectionProvider);
  if (selectedUuids.isEmpty) return 0;

  final encoder = ref.watch(shareEncoderProvider);
  return encoder.estimateSize(selectedUuids.toList());
});
