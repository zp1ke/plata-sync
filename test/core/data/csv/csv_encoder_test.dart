import 'package:flutter_test/flutter_test.dart';
import 'package:plata_sync/core/data/csv/csv_encoder.dart';

void main() {
  test('CsvEncoder escapes commas and quotes', () {
    const encoder = CsvEncoder();
    final csv = encoder.encode([
      ['name', 'note'],
      ['ACME, Inc', 'He said "hello"'],
    ]);

    expect(csv, 'name,note\n"ACME, Inc","He said ""hello"""');
  });

  test('CsvEncoder handles newlines', () {
    const encoder = CsvEncoder();
    final csv = encoder.encode([
      ['id', 'notes'],
      ['1', 'Line 1\nLine 2'],
    ]);

    expect(csv, 'id,notes\n"Line 1\nLine 2"');
  });
}
