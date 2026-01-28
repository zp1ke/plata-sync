import '../../features/accounts/data/interfaces/account_data_source.dart';
import '../../features/accounts/domain/entities/account.dart';
import '../../features/categories/data/interfaces/category_data_source.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../features/tags/data/interfaces/tag_data_source.dart';
import '../../features/tags/domain/entities/tag.dart';
import '../../features/transactions/data/interfaces/transaction_data_source.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../data/backup/backup_data_builder.dart';
import '../data/backup/backup_data_parser.dart';
import '../data/backup/file_picker.dart';
import '../data/backup/file_saver.dart';

/// Service for managing data operations (export, import, clear).
class DataService {
  final TransactionDataSource _transactionDataSource;
  final AccountDataSource _accountDataSource;
  final CategoryDataSource _categoryDataSource;
  final TagDataSource _tagDataSource;

  DataService({
    required TransactionDataSource transactionDataSource,
    required AccountDataSource accountDataSource,
    required CategoryDataSource categoryDataSource,
    required TagDataSource tagDataSource,
  }) : _transactionDataSource = transactionDataSource,
       _accountDataSource = accountDataSource,
       _categoryDataSource = categoryDataSource,
       _tagDataSource = tagDataSource;

  /// Export all data to a JSON file.
  ///
  /// Returns the [FileSaveResult] containing information about the save operation.
  /// Throws an exception if the export fails.
  Future<FileSaveResult> exportData() async {
    final transactions = await _transactionDataSource.getAll();
    final accounts = await _accountDataSource.getAll();
    final categories = await _categoryDataSource.getAll();
    final tags = await _tagDataSource.getAll();

    final jsonContent = const BackupDataBuilder().build(
      transactions: transactions,
      accounts: accounts,
      categories: categories,
      tags: tags,
    );

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final fileName = 'plata_sync_export_$timestamp.json';

    return await saveFile(fileName: fileName, content: jsonContent);
  }

  /// Import data from a JSON file.
  ///
  /// [replaceExisting] If true, all existing data will be cleared before importing.
  /// If false, the imported data will be appended to existing data.
  ///
  /// Returns the parsed [BackupData].
  /// Throws an exception if the import fails or user cancels.
  Future<BackupData> importData({required bool replaceExisting}) async {
    // Pick file
    final result = await pickFile();
    if (result == null) {
      throw Exception('File selection canceled');
    }

    // Parse backup data
    final parser = const BackupDataParser();
    final backupData = parser.parse(result.content);

    // Clear existing data if replace mode
    if (replaceExisting) {
      await clearAllData();
    }

    // Insert imported data
    await _insertData(
      accounts: backupData.accounts,
      categories: backupData.categories,
      tags: backupData.tags,
      transactions: backupData.transactions,
    );

    return backupData;
  }

  /// Clear all data from all data sources.
  ///
  /// Throws an exception if the operation fails.
  Future<void> clearAllData() async {
    // Clear transactions first (due to foreign key constraints)
    final existingTransactions = await _transactionDataSource.getAll();
    for (final transaction in existingTransactions) {
      await _transactionDataSource.delete(transaction.id);
    }

    // Clear accounts
    final existingAccounts = await _accountDataSource.getAll();
    for (final account in existingAccounts) {
      await _accountDataSource.delete(account.id);
    }

    // Clear categories
    final existingCategories = await _categoryDataSource.getAll();
    for (final category in existingCategories) {
      await _categoryDataSource.delete(category.id);
    }

    // Clear tags
    final existingTags = await _tagDataSource.getAll();
    for (final tag in existingTags) {
      await _tagDataSource.delete(tag.id);
    }
  }

  /// Insert data into the data sources.
  Future<void> _insertData({
    required List<Account> accounts,
    required List<Category> categories,
    required List<Tag> tags,
    required List<Transaction> transactions,
  }) async {
    // Insert in order to respect foreign key constraints
    for (final account in accounts) {
      await _accountDataSource.create(account);
    }

    for (final category in categories) {
      await _categoryDataSource.create(category);
    }

    for (final tag in tags) {
      await _tagDataSource.create(tag);
    }

    for (final transaction in transactions) {
      await _transactionDataSource.create(transaction);
    }
  }
}
