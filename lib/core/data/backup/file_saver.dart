import 'file_saver_types.dart';
import 'file_saver_stub.dart'
    if (dart.library.html) 'file_saver_web.dart'
    if (dart.library.io) 'file_saver_io.dart';

export 'file_saver_types.dart';

Future<FileSaveResult> saveFile({
  required String fileName,
  required String content,
}) {
  return saveFileImpl(fileName: fileName, content: content);
}
