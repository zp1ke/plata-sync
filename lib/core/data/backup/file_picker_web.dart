import 'package:file_selector/file_selector.dart';

import 'file_picker_types.dart';

Future<FilePickResult?> pickFileImpl() async {
  // Web: Use file selector
  const XTypeGroup typeGroup = XTypeGroup(
    label: 'JSON',
    extensions: ['json'],
    mimeTypes: ['application/json'],
  );

  final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

  if (file == null) {
    // User canceled the dialog
    return null;
  }

  final content = await file.readAsString();
  return FilePickResult(content: content);
}
