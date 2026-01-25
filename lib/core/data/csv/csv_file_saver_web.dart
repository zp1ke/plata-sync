import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';

import 'csv_types.dart';

Future<CsvSaveResult> saveCsvFileImpl({
  required String fileName,
  required String content,
}) async {
  final bytes = Uint8List.fromList(utf8.encode(content));
  await FileSaver.instance.saveFile(
    name: fileName,
    bytes: bytes,
    fileExtension: 'csv',
    mimeType: MimeType.csv,
  );
  return const CsvSaveResult(isDownload: true);
}
