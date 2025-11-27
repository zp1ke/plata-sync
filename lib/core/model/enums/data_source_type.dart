/// Enumeration of available data source types
enum DataSourceType {
  /// In-memory data source (data lost on app restart)
  inMemory,

  /// Local database data source (persistent)
  local;

  /// Get DataSource from string
  static DataSourceType fromKey(String name) {
    return DataSourceType.values.firstWhere(
      (source) => source.name == name,
      orElse: () => DataSourceType.inMemory,
    );
  }
}
