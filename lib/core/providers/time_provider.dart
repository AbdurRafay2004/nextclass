import 'package:flutter_riverpod/flutter_riverpod.dart';

// An isolated auto-updating clock stream that yields the current time immediately,
// and then updates every minute, synchronized with the system clock rollover.
final timeProvider = StreamProvider<DateTime>((ref) async* {
  // Yield initial time immediately
  yield DateTime.now();

  // Calculate delay until the next minute rollover
  final now = DateTime.now();
  final delay = 60 - now.second;

  // Wait for the next minute to start
  await Future.delayed(Duration(seconds: delay));

  // Yield the synchronized time
  yield DateTime.now();

  // Thereafter, update every minute
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});
