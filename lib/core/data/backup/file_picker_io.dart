import 'dart:io';

import 'package:file_selector/file_selector.dart';

import 'file_picker_types.dart';

Future<FilePickResult?> pickFileImpl() async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    // Desktop: Use file selector
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
  } else {
    // Mobile: Use file_picker package (needs to be added to pubspec.yaml)
    // For now, throw an error
    throw UnimplementedError('File picker not yet implemented for mobile');
  }
}
