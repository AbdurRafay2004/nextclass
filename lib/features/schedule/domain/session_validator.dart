class SessionValidator {
  static void validate({
    required int startTimeMinutes,
    required int durationMinutes,
    required int dayOfWeek,
    required String room,
  }) {
    if (startTimeMinutes < 0 || startTimeMinutes >= 24 * 60) {
      throw ArgumentError('Start time must be between 0 and 1439 minutes.');
    }
    if (durationMinutes <= 0) {
      throw ArgumentError('Duration must be greater than 0.');
    }
    if (dayOfWeek < 1 || dayOfWeek > 7) {
      throw ArgumentError('Day of week must be between 1 and 7.');
    }
    if (room.trim().isEmpty) {
      throw ArgumentError('Room cannot be empty.');
    }
  }
}
