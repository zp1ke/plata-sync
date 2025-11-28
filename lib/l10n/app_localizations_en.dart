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
  String get accountsSearchHint => 'Search accounts...';

  @override
  String get accountsEmptyState => 'No accounts yet';

  @override
  String accountsNoSearchResults(String query) {
    return 'No accounts found for \"$query\"';
  }

  @override
  String get accountsSelectPrompt => 'Select an account to view details';

  @override
  String get accountsAddButton => 'Add Account';

  @override
  String get accountsAddSampleDataPrompt =>
      'Would you like to add some sample accounts to get started?';

  @override
  String get accountsSortNameAsc => 'Name (A-Z)';

  @override
  String get accountsSortNameDesc => 'Name (Z-A)';

  @override
  String get accountsSortLastUsedAsc => 'Last Used (Oldest)';

  @override
  String get accountsSortLastUsedDesc => 'Last Used (Recent)';

  @override
  String get accountsSortBalanceAsc => 'Balance (Low to High)';

  @override
  String get accountsSortBalanceDesc => 'Balance (High to Low)';

  @override
  String accountCreated(String name) {
    return 'Account \"$name\" created';
  }

  @override
  String accountCreateFailed(String error) {
    return 'Failed to create account: $error';
  }

  @override
  String accountUpdated(String name) {
    return 'Account \"$name\" updated';
  }

  @override
  String accountUpdateFailed(String error) {
    return 'Failed to update account: $error';
  }

  @override
  String accountDeleted(String name) {
    return 'Account \"$name\" deleted';
  }

  @override
  String accountDeleteFailed(String name, String error) {
    return 'Failed to delete account \"$name\": $error';
  }

  @override
  String accountsDeleteConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String accountDuplicated(String name) {
    return 'Account \"$name\" duplicated';
  }

  @override
  String accountDuplicateFailed(String name, String error) {
    return 'Failed to duplicate account \"$name\": $error';
  }

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
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsAppVersion => 'Version';

  @override
  String get settingsDataSource => 'Data Source';

  @override
  String get settingsDataSourceInMemory => 'In-Memory';

  @override
  String get settingsDataSourceInMemoryDesc =>
      'Data is stored temporarily and will be lost when the app closes';

  @override
  String get settingsDataSourceLocal => 'Local Database';

  @override
  String get settingsDataSourceLocalDesc =>
      'Data is stored persistently in a local SQLite database';

  @override
  String get settingsDataSourceChangeTitle => 'Change Data Source?';

  @override
  String get settingsDataSourceChangeMessage =>
      'Changing the data source will require an app restart. Your current data will not be transferred automatically between different data sources.';

  @override
  String get settingsDataSourceChangedTitle => 'Data Source Changed';

  @override
  String get restartingApp => 'Restarting App';

  @override
  String get settingsDataSourceChangedRestartingMessage =>
      'The data source has been changed. Restarting the app to apply changes.';

  @override
  String get settingsDataSourceChangedMessage =>
      'The data source has been changed. Please restart the app to apply changes.';

  @override
  String get categoriesEmptyState => 'No categories yet';

  @override
  String get categoriesSelectPrompt => 'Select a category to view details';

  @override
  String get categoriesLastUsed => 'Last Used';

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
  String get ok => 'OK';

  @override
  String get optional => 'optional';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get accountsDetailsId => 'ID';

  @override
  String get accountsDetailsBalance => 'Balance';

  @override
  String get accountsDetailsCreatedAt => 'Created';

  @override
  String get accountsDetailsLastUsed => 'Last Used';

  @override
  String get accountsEditTitle => 'Edit Account';

  @override
  String get accountsCreateTitle => 'Create Account';

  @override
  String get accountsEditName => 'Name';

  @override
  String get accountsEditNameRequired => 'Name is required';

  @override
  String get accountsEditDescription => 'Description';

  @override
  String get accountsEditInitialBalance => 'Initial Balance';

  @override
  String get accountsEditInitialBalanceHelper =>
      'Enter the starting balance for this account';

  @override
  String get accountsEditInitialBalanceRequired =>
      'Initial balance is required';

  @override
  String get accountsEditInitialBalanceInvalid => 'Invalid amount format';

  @override
  String get accountsEditIcon => 'Account Icon';

  @override
  String get accountsEditIconRequired => 'Icon is required';

  @override
  String get accountsEditBackgroundColor => 'Background Color';

  @override
  String get accountsEditIconColor => 'Icon Color';

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

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get categoriesEditTitle => 'Edit Category';

  @override
  String get categoriesCreateTitle => 'Create Category';

  @override
  String get categoriesEditName => 'Name';

  @override
  String get categoriesEditNameRequired => 'Name is required';

  @override
  String get categoriesEditDescription => 'Description';

  @override
  String get categoriesEditIcon => 'Category Icon';

  @override
  String get categoriesEditIconHelper => 'e.g., shopping_cart, bolt, movie';

  @override
  String get categoriesEditIconRequired => 'Icon is required';

  @override
  String get categoriesEditBackgroundColor => 'Background Color';

  @override
  String get categoriesEditIconColor => 'Icon Color';

  @override
  String get categoriesEditColorHelper => 'Hex color (e.g., #FF5733 or FF5733)';

  @override
  String get categoriesEditColorRequired => 'Color is required';

  @override
  String get categoriesEditColorInvalid => 'Invalid hex color format';

  @override
  String get categoriesAddButton => 'Add Category';

  @override
  String categoryCreated(String categoryName) {
    return 'Category \"$categoryName\" created successfully.';
  }

  @override
  String categoryCreateFailed(String error) {
    return 'Failed to create category: $error';
  }

  @override
  String categoryUpdated(String categoryName) {
    return 'Category \"$categoryName\" updated successfully.';
  }

  @override
  String categoryUpdateFailed(String error) {
    return 'Failed to update category: $error';
  }

  @override
  String get iconShoppingCart => 'Shopping Cart';

  @override
  String get iconBolt => 'Bolt';

  @override
  String get iconMovie => 'Movie';

  @override
  String get iconRestaurant => 'Restaurant';

  @override
  String get iconHome => 'Home';

  @override
  String get iconCar => 'Car';

  @override
  String get iconFlight => 'Flight';

  @override
  String get iconGift => 'Gift';

  @override
  String get iconMedical => 'Medical';

  @override
  String get iconEducation => 'Education';

  @override
  String get iconEntertainment => 'Entertainment';

  @override
  String get iconTravel => 'Travel';

  @override
  String get iconFitness => 'Fitness';

  @override
  String get iconCoffee => 'Coffee';

  @override
  String get iconShoppingBag => 'Shopping Bag';

  @override
  String get iconMusic => 'Music';

  @override
  String get iconPets => 'Pets';

  @override
  String get iconTransportation => 'Transportation';

  @override
  String get iconFood => 'Food';

  @override
  String get iconClothing => 'Clothing';

  @override
  String get iconHealth => 'Health';

  @override
  String get iconSalary => 'Salary';

  @override
  String get iconFlashOn => 'Flash On';

  @override
  String get iconAccountBalance => 'Account Balance';

  @override
  String get iconSavings => 'Savings';

  @override
  String get iconCreditCard => 'Credit Card';

  @override
  String get iconPayments => 'Payments';

  @override
  String get iconUnknown => 'Unknown';

  @override
  String get selectFieldSearchHint => 'Search...';

  @override
  String get selectFieldNoResults => 'No results found';

  @override
  String get selectFieldCancel => 'Cancel';
}
