import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/os.dart';

/// Service for managing the SQLite database
class DatabaseService {
  static const String _databaseName = 'plata_sync.db';
  static const int _databaseVersion = 3;

  Database? _database;
  DatabaseService() {
    if (isDesktopPlatform()) {
      /// Initialize sqflite for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  /// Get the database instance (singleton pattern)
  Future<Database> get database async {
    // Return cached instance if available
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
        description TEXT,
        transaction_type TEXT,
        enabled INTEGER NOT NULL DEFAULT 1
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
        balance INTEGER NOT NULL DEFAULT 0,
        enabled INTEGER NOT NULL DEFAULT 1,
        supports_effective_date INTEGER NOT NULL DEFAULT 0,
        supports_installments INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        account_id TEXT NOT NULL,
        category_id TEXT,
        amount INTEGER NOT NULL,
        account_balance_before INTEGER NOT NULL DEFAULT 0,
        target_account_id TEXT,
        target_account_balance_before INTEGER,
        notes TEXT,
        tag_ids TEXT,
        effective_date INTEGER,
        parent_transaction_id TEXT,
        FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
        FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE,
        FOREIGN KEY (parent_transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
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

    await db.execute('''
      CREATE INDEX idx_transactions_parent_transaction_id ON transactions(parent_transaction_id)
    ''');

    // Create tags table
    await db.execute('''
      CREATE TABLE tags (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        created_at INTEGER NOT NULL,
        last_used_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_tags_name ON tags(name)
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration from version 1 to 2: Add supports_effective_date and supports_installments columns
      await db.execute(
        'ALTER TABLE accounts ADD COLUMN supports_effective_date INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE accounts ADD COLUMN supports_installments INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 3) {
      // Migration from version 2 to 3: Add effective_date column to transactions
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN effective_date INTEGER',
      );
    }
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
