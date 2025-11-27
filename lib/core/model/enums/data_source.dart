/// Enumeration of available data source types
enum DataSource {
  /// In-memory data source (data lost on app restart)
  inMemory,

  /// Local database data source (persistent)
  local;

  /// Get DataSource from string
  static DataSource fromKey(String name) {
    return DataSource.values.firstWhere(
      (source) => source.name == name,
      orElse: () => DataSource.inMemory,
    );
  }
}
