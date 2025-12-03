import 'package:intl/intl.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/date_format_type.dart';
import 'package:plata_sync/core/model/enums/time_format_type.dart';
import 'package:plata_sync/core/services/settings_service.dart';

extension DateExtensions on DateTime {
  /// Formats DateTime according to user's date format preference.
  String format() {
    final settings = getService<SettingsService>();
    final dateFormatType = settings.getDateFormat();

    final dateFormat = switch (dateFormatType) {
      DateFormatType.long => DateFormat.yMMMd(),
      DateFormatType.short => DateFormat.yMd(),
    };

    return dateFormat.format(this);
  }

  /// Formats DateTime with time according to user's preferences.
  String formatWithTime() {
    final settings = getService<SettingsService>();
    final dateFormatType = settings.getDateFormat();
    final timeFormatType = settings.getTimeFormat();

    final dateFormat = switch (dateFormatType) {
      DateFormatType.long => DateFormat.yMMMd(),
      DateFormatType.short => DateFormat.yMd(),
    };

    final timeFormat = switch (timeFormatType) {
      TimeFormatType.hour12 => DateFormat.jm(),
      TimeFormatType.hour24 => DateFormat.Hm(),
    };

    return '${dateFormat.format(this)} ${timeFormat.format(this)}';
  }
}
