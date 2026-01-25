import 'csv_types.dart';
import 'csv_file_saver_stub.dart'
    if (dart.library.html) 'csv_file_saver_web.dart'
    if (dart.library.io) 'csv_file_saver_io.dart';

Future<CsvSaveResult> saveCsvFile({
  required String fileName,
  required String content,
}) {
  return saveCsvFileImpl(fileName: fileName, content: content);
}
