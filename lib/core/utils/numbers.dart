import 'package:intl/intl.dart';

/// Utility class for number formatting, particularly for currency.
class NumberFormatters {
  // Private constructor to prevent instantiation
  NumberFormatters._();

  // Cache formatters for better performance
  static final _currencyFormatter = NumberFormat.currency(symbol: '\$');
  static final _compactCurrencyFormatter = NumberFormat.compactCurrency(
    symbol: '\$',
  );
  static final _wholeCurrencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  /// Formats a value in cents as currency with dollar sign.
  /// Example: 150000 cents -> "$1,500.00"
  static String formatCurrency(int cents) {
    return _currencyFormatter.format(cents / 100);
  }

  /// Formats a value in cents as compact currency with dollar sign.
  /// Example: 150000 cents -> "$1.5K"
  static String formatCompactCurrency(int cents) {
    return _compactCurrencyFormatter.format(cents / 100);
  }

  /// Formats a value in cents as currency without decimal places.
  /// Example: 150000 cents -> "$1,500"
  static String formatCurrencyWhole(int cents) {
    return _wholeCurrencyFormatter.format(cents / 100);
  }
}

/// Extension methods for int type.
extension IntExtensions on int {
  /// Minimum safe integer value.
  static int get minSafeValue => -9007199254740991;
}
