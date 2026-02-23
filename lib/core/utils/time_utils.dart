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

/// Returns a human-readable day label with date relative to [now].
/// "Tomorrow, Oct 25" if [targetDate] is the next day, otherwise the full
/// day name and date (e.g. "Wednesday, Oct 26").
String dayLabel(DateTime now, DateTime targetDate) {
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final isTomorrow =
      targetDate.year == tomorrow.year &&
      targetDate.month == tomorrow.month &&
      targetDate.day == tomorrow.day;

  if (isTomorrow) {
    final dateFormat = DateFormat('MMM d');
    return 'Tomorrow, ${dateFormat.format(targetDate)}';
  }

  return DateFormat('EEEE, MMM d').format(targetDate);
}
