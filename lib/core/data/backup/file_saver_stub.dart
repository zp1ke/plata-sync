import 'file_saver_types.dart';

Future<FileSaveResult> saveFileImpl({
  required String fileName,
  required String content,
}) async {
  throw UnsupportedError('File export is not supported on this platform.');
}
