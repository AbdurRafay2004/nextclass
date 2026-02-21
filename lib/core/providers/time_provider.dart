import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A stream that emits the current system time every 30 seconds.
/// The UI only displays minute-level granularity (h:mm), so polling
/// every 30 seconds is sufficient to stay in sync while saving battery.
final timeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});
