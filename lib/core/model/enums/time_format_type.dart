/// Enumeration of available time format types
enum TimeFormatType {
  /// 12-hour time format with AM/PM (e.g., "2:30 PM")
  hour12,

  /// 24-hour time format (e.g., "14:30")
  hour24;

  /// Get TimeFormatType from string
  static TimeFormatType fromKey(String name) {
    return TimeFormatType.values.firstWhere(
      (format) => format.name == name,
      orElse: () => TimeFormatType.hour12,
    );
  }
}
