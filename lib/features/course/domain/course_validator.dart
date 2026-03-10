class CourseValidator {
  static void validate({
    required String name,
    required String code,
    required String colorHex,
    required String facultyAcronym,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Course name cannot be empty.');
    }
    if (code.trim().isEmpty) {
      throw ArgumentError('Course code cannot be empty.');
    }
    if (colorHex.trim().isEmpty) {
      throw ArgumentError('Course color cannot be empty.');
    }
    if (facultyAcronym.trim().isEmpty) {
      throw ArgumentError('Faculty acronym cannot be empty.');
    }
  }
}
