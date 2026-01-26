import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';

import 'file_saver_types.dart';

Future<FileSaveResult> saveFileImpl({
  required String fileName,
  required String content,
}) async {
  final bytes = Uint8List.fromList(utf8.encode(content));

  final parts = fileName.split('.');
  final ext = parts.length > 1 ? parts.last : 'json';
  final name = parts.length > 1
      ? parts.sublist(0, parts.length - 1).join('.')
      : fileName;

  MimeType mimeType = MimeType.json;
  if (ext == 'csv') mimeType = MimeType.csv;

  await FileSaver.instance.saveFile(
    name: name,
    bytes: bytes,
    fileExtension: ext,
    mimeType: mimeType,
  );
  return const FileSaveResult(isDownload: true);
}
