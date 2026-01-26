import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart';

import 'file_saver_types.dart';

Future<FileSaveResult> saveFileImpl({
  required String fileName,
  required String content,
}) async {
  final parts = fileName.split('.');
  final ext = parts.length > 1 ? parts.last : 'json';

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    // Desktop: Prompt user for save location
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [
        const XTypeGroup(
          label: 'JSON',
          extensions: ['json'],
          mimeTypes: ['application/json'],
        ),
      ],
    );

    if (result == null) {
      // User canceled the dialog
      throw Exception('Export canceled');
    }

    final file = File(result.path);
    await file.writeAsString(content);
    return FileSaveResult(path: file.path);
  } else {
    // Mobile: Use FileSaver to save (it handles permissions and paths internally)
    final bytes = Uint8List.fromList(utf8.encode(content));
    final name = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('.')
        : fileName;

    MimeType mimeType = MimeType.json;
    if (ext == 'csv') mimeType = MimeType.csv;

    final path = await FileSaver.instance.saveFile(
      name: name,
      bytes: bytes,
      fileExtension: ext,
      mimeType: mimeType,
    );
    return FileSaveResult(path: path);
  }
}
