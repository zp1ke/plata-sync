import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart';

import 'csv_types.dart';

Future<CsvSaveResult> saveCsvFileImpl({
  required String fileName,
  required String content,
}) async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    // Desktop: Prompt user for save location
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [
        const XTypeGroup(
          label: 'CSV',
          extensions: ['csv'],
          mimeTypes: ['text/csv'],
        ),
      ],
    );

    if (result == null) {
      // User canceled the dialog
      throw Exception('Export canceled');
    }

    final file = File(result.path);
    await file.writeAsString(content);
    return CsvSaveResult(path: file.path);
  } else {
    // Mobile: Use FileSaver to save (it handles permissions and paths internally)
    final bytes = Uint8List.fromList(utf8.encode(content));
    final path = await FileSaver.instance.saveFile(
      name: fileName.replaceAll('.csv', ''), // FileSaver adds extension
      bytes: bytes,
      fileExtension: 'csv',
      mimeType: MimeType.csv,
    );
    return CsvSaveResult(path: path);
  }
}
