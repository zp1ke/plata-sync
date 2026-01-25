class CsvEncoder {
  const CsvEncoder();

  String encode(List<List<String>> rows) {
    if (rows.isEmpty) return '';
    return rows.map((row) => row.map(_escape).join(',')).join('\n');
  }

  String _escape(String value) {
    final needsQuotes =
        value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');
    if (!needsQuotes) return value;
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
