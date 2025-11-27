import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Service for managing the SQLite database
class DatabaseService {
  static const String _databaseName = 'plata_sync.db';
  static const int _databaseVersion = 1;

  Database? _database;

  /// Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        background_color_hex TEXT NOT NULL,
        icon_color_hex TEXT NOT NULL,
        last_used INTEGER,
        description TEXT
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations will be handled here
  }

  /// Close the database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
