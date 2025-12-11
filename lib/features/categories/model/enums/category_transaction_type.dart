/// The type of transactions that a category applies to
enum CategoryTransactionType {
  /// Category is only for income transactions
  income,

  /// Category is only for expense transactions
  expense;

  /// Get CategoryTransactionType from string, returns null if not found
  static CategoryTransactionType? fromString(String? value) {
    if (value == null) return null;
    return CategoryTransactionType.values
        .where((type) => type.name == value)
        .firstOrNull;
  }

  /// Convert to string for database storage
  String toDbString() => name;
}
