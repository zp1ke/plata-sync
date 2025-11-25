import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  /// Formats DateTime.
  String format() {
    final dateFormat = DateFormat.yMMMd();
    return dateFormat.format(this);
  }
}
