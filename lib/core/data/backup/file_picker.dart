import 'file_picker_types.dart';
import 'file_picker_stub.dart'
    if (dart.library.html) 'file_picker_web.dart'
    if (dart.library.io) 'file_picker_io.dart';

export 'file_picker_types.dart';

Future<FilePickResult?> pickFile() {
  return pickFileImpl();
}
