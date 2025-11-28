import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  /// Formats DateTime.
  String format() {
    final dateFormat = DateFormat.yMMMd();
    return dateFormat.format(this);
  }

  /// Formats DateTime with time (hours and minutes).
  String formatWithTime() {
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.Hm();
    return '${dateFormat.format(this)} ${timeFormat.format(this)}';
  }
}
