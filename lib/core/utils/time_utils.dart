import 'package:intl/intl.dart';

/// Formats minutes-since-midnight into a time string (e.g., '10:30 AM').
String formatTime(int minutesSinceMidnight) {
  final now = DateTime.now();
  final time = DateTime(
    now.year,
    now.month,
    now.day,
    minutesSinceMidnight ~/ 60,
    minutesSinceMidnight % 60,
  );
  return DateFormat('h:mm a').format(time);
}

/// Formats minutes-since-midnight into just the time part (e.g., '10:30').
String formatTimeOnly(int minutesSinceMidnight) {
  final now = DateTime.now();
  final time = DateTime(
    now.year,
    now.month,
    now.day,
    minutesSinceMidnight ~/ 60,
    minutesSinceMidnight % 60,
  );
  return DateFormat('h:mm').format(time);
}

/// Formats minutes-since-midnight into just the AM/PM part.
String formatAmPm(int minutesSinceMidnight) {
  final now = DateTime.now();
  final time = DateTime(
    now.year,
    now.month,
    now.day,
    minutesSinceMidnight ~/ 60,
    minutesSinceMidnight % 60,
  );
  return DateFormat('a').format(time);
}
