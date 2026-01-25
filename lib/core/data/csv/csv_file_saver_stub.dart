import 'csv_types.dart';

Future<CsvSaveResult> saveCsvFileImpl({
  required String fileName,
  required String content,
}) async {
  throw UnsupportedError('CSV export is not supported on this platform.');
}
