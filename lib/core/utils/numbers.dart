import 'package:intl/intl.dart';

/// Utility class for number formatting, particularly for currency.
class NumberFormatters {
  NumberFormatters._();

  /// Formats a value in cents as currency with dollar sign.
  /// Example: 150000 cents -> "$1,500.00"
  static String formatCurrency(int cents) {
    final format = NumberFormat.currency(symbol: '\$');
    return format.format(cents / 100);
  }

  /// Formats a value in cents as compact currency with dollar sign.
  /// Example: 150000 cents -> "$1.5K"
  static String formatCompactCurrency(int cents) {
    final format = NumberFormat.compactCurrency(symbol: '\$');
    return format.format(cents / 100);
  }

  /// Formats a value in cents as currency without decimal places.
  /// Example: 150000 cents -> "$1,500"
  static String formatCurrencyWhole(int cents) {
    final format = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return format.format(cents / 100);
  }
}

/// Extension methods for int type.
extension IntExtensions on int {
  /// Minimum safe integer value.
  static int get minSafeValue => -9007199254740991;
}
