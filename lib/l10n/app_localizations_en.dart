// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Plata Sync';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get transactionsScreenTitle => 'Transactions';

  @override
  String get transactionsScreenBody => 'Transactions Screen';

  @override
  String get accountsScreenTitle => 'Accounts';

  @override
  String get accountsScreenBody => 'Accounts Screen';

  @override
  String get navCategories => 'Categories';

  @override
  String get categoriesScreenTitle => 'Categories';

  @override
  String get categoriesScreenBody => 'Categories Screen';

  @override
  String get categoriesSearchHint => 'Search Categories';

  @override
  String get categoriesAddSampleDataPrompt =>
      'Would you like to add sample categories to get started?';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsScreenBody => 'Settings Screen';

  @override
  String get categoriesEmptyState => 'No categories yet';

  @override
  String categoriesNoSearchResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get categoriesSortNameAsc => 'Name (A-Z)';

  @override
  String get categoriesSortNameDesc => 'Name (Z-A)';

  @override
  String get categoriesSortLastUsedAsc => 'Last Used (Oldest)';

  @override
  String get categoriesSortLastUsedDesc => 'Last Used (Newest)';

  @override
  String get viewList => 'List View';

  @override
  String get viewGrid => 'Grid View';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get categoriesDetailsId => 'ID';

  @override
  String get categoriesDetailsLastUsed => 'Last Used';

  @override
  String get categoriesDetailsIcon => 'Icon';

  @override
  String get categoriesDetailsBackgroundColor => 'Background';

  @override
  String get categoriesDetailsIconColor => 'Icon Color';

  @override
  String get copy => 'Copy';

  @override
  String categoryDuplicated(String categoryName) {
    return 'Category \"$categoryName\" duplicated successfully.';
  }

  @override
  String categoryDuplicateFailed(String categoryName, String error) {
    return 'Failed to duplicate category \"$categoryName\": $error';
  }

  @override
  String categoriesDeleteConfirmation(String categoryName) {
    return 'Are you sure you want to delete \"$categoryName\"?';
  }

  @override
  String categoryDeleted(String categoryName) {
    return 'Category \"$categoryName\" deleted successfully.';
  }

  @override
  String categoryDeleteFailed(String categoryName, String error) {
    return 'Failed to delete category \"$categoryName\": $error';
  }

  @override
  String get never => 'Never';

  @override
  String get categoriesDetailsCreatedAt => 'Created At';
}
