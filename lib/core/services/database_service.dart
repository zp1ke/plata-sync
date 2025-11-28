import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Service for managing the SQLite database
class DatabaseService {
  static const String _databaseName = 'plata_sync.db';
  static const int _databaseVersion = 1;

  Database? _database;
  DatabaseService() {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      /// Initialize sqflite for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

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
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');

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

    await db.execute('''
      CREATE TABLE accounts (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        background_color_hex TEXT NOT NULL,
        icon_color_hex TEXT NOT NULL,
        last_used INTEGER,
        description TEXT,
        balance INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        account_id TEXT NOT NULL,
        category_id TEXT,
        amount INTEGER NOT NULL,
        target_account_id TEXT,
        notes TEXT,
        FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
        FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for foreign keys to improve query performance
    await db.execute('''
      CREATE INDEX idx_transactions_account_id ON transactions(account_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_category_id ON transactions(category_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_target_account_id ON transactions(target_account_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_created_at ON transactions(created_at)
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
