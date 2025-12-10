import 'package:package_info_plus/package_info_plus.dart';
import '../model/enums/data_source_type.dart';
import '../model/enums/date_format_type.dart';
import '../model/enums/time_format_type.dart';
import '../../features/accounts/model/enums/sort_order.dart';
import '../../features/categories/model/enums/sort_order.dart';
import '../../features/transactions/model/enums/sort_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing application settings using SharedPreferences
class SettingsService {
  static const String _keyDataSource = 'data_source';
  static const String _keyDateFormat = 'date_format';
  static const String _keyTimeFormat = 'time_format';
  static const String _keyAccountsSortOrder = 'accounts_sort_order';
  static const String _keyCategoriesSortOrder = 'categories_sort_order';
  static const String _keyTransactionsSortOrder = 'transactions_sort_order';

  final SharedPreferences _prefs;
  final PackageInfo _packageInfo;

  SettingsService(this._prefs, this._packageInfo);

  /// Get the current data source setting
  DataSourceType getDataSource() {
    final key = _prefs.getString(_keyDataSource);
    if (key == null) return DataSourceType.local;
    return DataSourceType.fromKey(key);
  }

  /// Set the data source setting
  Future<bool> setDataSource(DataSourceType source) async {
    return await _prefs.setString(_keyDataSource, source.name);
  }

  /// Get the current date format setting
  DateFormatType getDateFormat() {
    final key = _prefs.getString(_keyDateFormat);
    if (key == null) return DateFormatType.short;
    return DateFormatType.fromKey(key);
  }

  /// Set the date format setting
  Future<bool> setDateFormat(DateFormatType format) async {
    return await _prefs.setString(_keyDateFormat, format.name);
  }

  /// Get the current time format setting
  TimeFormatType getTimeFormat() {
    final key = _prefs.getString(_keyTimeFormat);
    if (key == null) return TimeFormatType.hour12;
    return TimeFormatType.fromKey(key);
  }

  /// Set the time format setting
  Future<bool> setTimeFormat(TimeFormatType format) async {
    return await _prefs.setString(_keyTimeFormat, format.name);
  }

  /// Get the accounts sort order setting
  AccountSortOrder? getAccountsSortOrder() {
    final value = _prefs.getString(_keyAccountsSortOrder);
    if (value != null) {
      try {
        return AccountSortOrder.values.byName(value);
      } catch (_) {}
    }
    return null;
  }

  /// Set the accounts sort order setting
  Future<bool> setAccountsSortOrder(AccountSortOrder sortOrder) async {
    return await _prefs.setString(_keyAccountsSortOrder, sortOrder.name);
  }

  /// Get the categories sort order setting
  CategorySortOrder? getCategoriesSortOrder() {
    final value = _prefs.getString(_keyCategoriesSortOrder);
    if (value != null) {
      try {
        return CategorySortOrder.values.byName(value);
      } catch (_) {}
    }
    return null;
  }

  /// Set the categories sort order setting
  Future<bool> setCategoriesSortOrder(CategorySortOrder sortOrder) async {
    return await _prefs.setString(_keyCategoriesSortOrder, sortOrder.name);
  }

  /// Get the transactions sort order setting
  TransactionSortOrder? getTransactionsSortOrder() {
    final value = _prefs.getString(_keyTransactionsSortOrder);
    if (value != null) {
      try {
        return TransactionSortOrder.values.byName(value);
      } catch (_) {}
    }
    return null;
  }

  /// Set the transactions sort order setting
  Future<bool> setTransactionsSortOrder(TransactionSortOrder sortOrder) async {
    return await _prefs.setString(_keyTransactionsSortOrder, sortOrder.name);
  }

  /// Get the app version string
  String getAppVersion() {
    return '${_packageInfo.version}+${_packageInfo.buildNumber}';
  }

  /// Clear all settings
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
