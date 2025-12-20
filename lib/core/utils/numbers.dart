import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

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
  static String _formatCurrency(int cents) {
    return _currencyFormatter.format(cents / 100);
  }

  /// Formats a value in cents as compact currency with dollar sign.
  /// For values in the thousands or higher, it uses abbreviations like K, M, etc.
  /// For values less than 1000, it shows the full amount.
  /// Example: 150000 cents -> "$1.5K"
  static String _formatCompactCurrency(int cents) {
    if (cents.abs() < 100000) {
      // For amounts less than $1,000, show full currency format
      return _currencyFormatter.format(cents / 100);
    }
    return _compactCurrencyFormatter.format(cents / 100);
  }

  /// Formats a value in cents as currency without decimal places.
  /// Example: 150000 cents -> "$1,500"
  static String _formatCurrencyWhole(int cents) {
    return _wholeCurrencyFormatter.format(cents / 100);
  }
}

/// Extension methods for int type.
extension IntExtensions on int {
  /// Minimum safe integer value.
  static int get minSafeValue => -9007199254740991;

  /// Formats a value in cents as currency with dollar sign.
  /// Example: 150000 cents -> "$1,500.00"
  String asCurrency() {
    return NumberFormatters._formatCurrency(this);
  }

  /// Formats a value in cents as compact currency with dollar sign.
  /// Example: 150000 cents -> "$1.5K"
  String asCompactCurrency() {
    return NumberFormatters._formatCompactCurrency(this);
  }

  /// Formats a value in cents as currency without decimal places.
  /// Example: 150000 cents -> "$1,500"
  String asWholeCurrency() {
    return NumberFormatters._formatCurrencyWhole(this);
  }
}

/// Utility method for evaluating simple mathematical expressions.
double evaluateExpression(String expression) {
  final input = expression.replaceAll('x', '*');
  if (input.isEmpty) return 0.0;

  // Check if it's just a number, if so, format it
  if (double.tryParse(expression) != null) {
    return double.parse(expression);
  }

  final p = GrammarParser();
  final exp = p.parse(input);
  final eval = RealEvaluator(ContextModel()).evaluate(exp);
  return eval.toDouble();
}
