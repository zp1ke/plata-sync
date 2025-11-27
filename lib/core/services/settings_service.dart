import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing application settings using SharedPreferences
class SettingsService {
  static const String _keyDataSource = 'data_source';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  /// Get the current data source setting
  DataSourceType getDataSource() {
    final key = _prefs.getString(_keyDataSource);
    if (key == null) return DataSourceType.inMemory;
    return DataSourceType.fromKey(key);
  }

  /// Set the data source setting
  Future<bool> setDataSource(DataSourceType source) async {
    return await _prefs.setString(_keyDataSource, source.name);
  }

  /// Clear all settings
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
