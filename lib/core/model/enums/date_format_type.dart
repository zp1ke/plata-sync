/// Enumeration of available date format types
enum DateFormatType {
  /// Long date format (e.g., "December 2, 2025")
  long,

  /// Short date format (e.g., "12/2/2025")
  short;

  /// Get DateFormatType from string
  static DateFormatType fromKey(String name) {
    return DateFormatType.values.firstWhere(
      (format) => format.name == name,
      orElse: () => DateFormatType.long,
    );
  }
}
