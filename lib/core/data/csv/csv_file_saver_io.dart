import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'csv_types.dart';

Future<CsvSaveResult> saveCsvFileImpl({
  required String fileName,
  required String content,
}) async {
  Directory? directory;
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    try {
      directory = await getDownloadsDirectory();
    } catch (_) {
      directory = null;
    }
  }
  directory ??= await getApplicationDocumentsDirectory();

  final safeFileName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '-');
  final file = File('${directory.path}/$safeFileName');
  await file.writeAsString(content);
  return CsvSaveResult(path: file.path);
}
