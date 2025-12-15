import 'dart:io';

import 'package:flutter/foundation.dart';

bool isMobilePlatform() {
  return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}

bool isDesktopPlatform() {
  return !kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
}
