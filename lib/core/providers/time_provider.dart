import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits the current system time immediately on subscribe, then every
/// 30 seconds. The immediate emission is critical — without it the
/// dashboard blocks for up to 30 s on app launch because
/// [Stream.periodic] waits one full interval before its first tick.
final timeProvider = StreamProvider<DateTime>((ref) {
  return _timeStream();
});

Stream<DateTime> _timeStream() async* {
  yield DateTime.now(); // ← Instant first emission
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
}
