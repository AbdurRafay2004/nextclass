import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple stream that emits the current system time every second.
/// Checking every second guarantees the app clock is perfectly in sync
/// with the phone's system clock.
final timeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
