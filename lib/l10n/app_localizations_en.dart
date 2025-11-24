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
}
