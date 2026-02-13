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
  String get transactionsAddButton => 'Add Transaction';

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
  String get settingsExportData => 'Export Data';

  @override
  String get settingsExportDataDesc =>
      'Export all your data to a JSON backup file';

  @override
  String get settingsExportStarted => 'Export started. Check your downloads.';

  @override
  String get settingsExportSuccess => 'Export complete.';

  @override
  String settingsExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get settingsImportData => 'Import Data';

  @override
  String get settingsImportDataDesc => 'Import data from a JSON backup file';

  @override
  String get settingsImportSuccess => 'Data imported successfully';

  @override
  String settingsImportFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get settingsImportModeTitle => 'Import Mode';

  @override
  String get settingsImportModeAppend => 'Append';

  @override
  String get settingsImportModeAppendDesc =>
      'Add imported data to existing data';

  @override
  String get settingsImportModeReplace => 'Replace';

  @override
  String get settingsImportModeReplaceDesc =>
      'Delete all existing data and replace with imported data';

  @override
  String get settingsClearData => 'Clear All Data';

  @override
  String get settingsClearDataDesc =>
      'Delete all accounts, categories, tags, and transactions';

  @override
  String get settingsClearDataConfirmTitle => 'Clear All Data?';

  @override
  String get settingsClearDataConfirmMessage =>
      'This will permanently delete all your accounts, categories, tags, and transactions. This action cannot be undone.';

  @override
  String get settingsClearDataSuccess => 'All data cleared successfully';

  @override
  String settingsClearDataFailed(String error) {
    return 'Failed to clear data: $error';
  }

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsAppVersion => 'Version';

  @override
  String get settingsLicenses => 'Open Source Licenses';

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
  String get settingsDateFormatLong => 'Long Date Format';

  @override
  String get settingsDateFormatLongExample => 'e.g., December 2, 2025';

  @override
  String get settingsDateFormatShort => 'Short Date Format';

  @override
  String get settingsDateFormatShortExample => 'e.g., 12/2/2025';

  @override
  String get settingsTimeFormat12h => '12-Hour Time';

  @override
  String get settingsTimeFormat12hExample => 'e.g., 2:30 PM';

  @override
  String get settingsTimeFormat24h => '24-Hour Time';

  @override
  String get settingsTimeFormat24hExample => 'e.g., 14:30';

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
  String get filterCategories => 'Filter Categories';

  @override
  String get categoryTypeFilter => 'Category Type';

  @override
  String get categoryTypeAll => 'All';

  @override
  String get categoryTypeIncome => 'Income';

  @override
  String get categoryTypeExpense => 'Expense';

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
  String get accountsDetailsEnabled => 'Enabled';

  @override
  String get accountsViewTransactions => 'View Transactions';

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
  String get accountsEditSupportsEffectiveDate => 'Supports Effective Date';

  @override
  String get accountsEditSupportsEffectiveDateHelper =>
      'Allow transactions to have a future effective date';

  @override
  String get accountsEditSupportsInstallments => 'Supports Installments';

  @override
  String get accountsEditSupportsInstallmentsHelper =>
      'Allow expense transactions to be split into multiple installments';

  @override
  String get accountsEditEnabled => 'Enabled';

  @override
  String get accountsEditEnabledHelper =>
      'Disabled accounts appear last and won\'t show in selectors.';

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
  String get categoriesDetailsEnabled => 'Enabled';

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
  String get categoriesDetailsViewTransactions => 'View Transactions';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get editIcon => 'Edit Icon';

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
  String get categoriesEditTransactionType => 'Transaction Type';

  @override
  String get categoriesEditTransactionTypeHelper =>
      'Leave \'Any\' to allow for both \'Income\' and \'Expense\'';

  @override
  String get categoriesEditEnabled => 'Enabled';

  @override
  String get categoriesEditEnabledHelper =>
      'Disabled categories appear last and won\'t show in selectors.';

  @override
  String get categoryTransactionTypeIncome => 'Income';

  @override
  String get categoryTransactionTypeExpense => 'Expense';

  @override
  String get categoryTransactionTypeAny => 'Any';

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
  String get unknown => 'Unknown';

  @override
  String get selectFieldSearchHint => 'Search...';

  @override
  String get selectFieldNoResults => 'No results found';

  @override
  String get none => 'None';

  @override
  String get selectFieldCancel => 'Cancel';

  @override
  String get transactionTypeExpense => 'Expense';

  @override
  String get transactionTypeIncome => 'Income';

  @override
  String get transactionTypeTransfer => 'Transfer';

  @override
  String get transactionDateLabel => 'Date';

  @override
  String get transactionEffectiveDateLabel => 'Effective Date';

  @override
  String transactionDateFormat(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get transactionAccountLabel => 'Account';

  @override
  String get transactionSourceAccountLabel => 'Source Account';

  @override
  String get transactionTargetAccountLabel => 'Target Account';

  @override
  String get transactionCategoryLabel => 'Category';

  @override
  String get dateFilterToday => 'Today';

  @override
  String get dateFilterWeek => 'This Week';

  @override
  String get dateFilterMonth => 'This Month';

  @override
  String get dateFilterAll => 'All Time';

  @override
  String get filterTransactions => 'Filter Transactions';

  @override
  String get transactionTypeFilter => 'Transaction Type';

  @override
  String get transactionTypeAll => 'All';

  @override
  String get selectAccount => 'Select Account';

  @override
  String get searchAccounts => 'Search accounts...';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get searchCategories => 'Search categories...';

  @override
  String get selectCategories => 'Select Categories';

  @override
  String get selectAccounts => 'Select Accounts';

  @override
  String get selectTags => 'Select Tags';

  @override
  String get searchTags => 'Search tags...';

  @override
  String get clear => 'Clear';

  @override
  String get apply => 'Apply';

  @override
  String get transactionAccountRequired => 'Account is required';

  @override
  String get transactionTargetAccountRequired => 'Target account is required';

  @override
  String get transactionTargetAccountSameError =>
      'Target account must be different from source account';

  @override
  String get transactionAmountLabel => 'Amount';

  @override
  String get transactionAmountRequired => 'Amount is required';

  @override
  String get transactionAmountMustBePositive =>
      'Amount must be greater than zero';

  @override
  String get transactionNotesLabel => 'Notes';

  @override
  String get transactionNotesHint => 'Add optional notes';

  @override
  String get saveButton => 'Save';

  @override
  String get transactionCreateTitle => 'New Transaction';

  @override
  String get transactionEditTitle => 'Edit Transaction';

  @override
  String get transactionIdLabel => 'Transaction ID';

  @override
  String get transactionsEmptyState => 'No transactions yet';

  @override
  String get transactionsEmptyFilteredState =>
      'No transactions found with current filters';

  @override
  String transactionsEmptyDateFilteredState(String dateFilter) {
    return 'No transactions found for $dateFilter';
  }

  @override
  String get transactionsSelectPrompt => 'Select a transaction to view details';

  @override
  String get transactionsAddSampleDataPrompt =>
      'Would you like to add some sample transactions to get started?';

  @override
  String get transactionsSortDateAsc => 'Date (Oldest First)';

  @override
  String get transactionsSortDateDesc => 'Date (Newest First)';

  @override
  String get transactionsSortAmountAsc => 'Amount (Low to High)';

  @override
  String get transactionsSortAmountDesc => 'Amount (High to Low)';

  @override
  String get transactionCreated => 'Transaction created';

  @override
  String transactionCreateFailed(String error) {
    return 'Failed to create transaction: $error';
  }

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String transactionUpdateFailed(String error) {
    return 'Failed to update transaction: $error';
  }

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String transactionDeleteFailed(String error) {
    return 'Failed to delete transaction: $error';
  }

  @override
  String get transactionsDeleteConfirmation =>
      'Are you sure you want to delete this transaction?';

  @override
  String get addSampleData => 'Add Sample Data';

  @override
  String get sampleDataCreated => 'Sample data created successfully';

  @override
  String sampleDataCreateFailed(String error) {
    return 'Failed to create sample data: $error';
  }

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get refresh => 'Refresh';

  @override
  String get iconTransfer => 'Transfer';

  @override
  String get transactionBalanceMovementLabel => 'Balance Movement';

  @override
  String get transactionTagsLabel => 'Tags';

  @override
  String get transactionTagsHint => 'Add tags...';

  @override
  String get add => 'Add';

  @override
  String errorCreatingTagMessage(String error) {
    return 'Failed to create tag: $error';
  }

  @override
  String get done => 'Done';

  @override
  String get fieldRequiredError => 'This field is required';

  @override
  String get invalidAmountError => 'Invalid amount format';

  @override
  String get go => 'Go';

  @override
  String get search => 'Search';

  @override
  String get send => 'Send';

  @override
  String get next => 'Next';

  @override
  String get categoriesNoTypeFilterResults =>
      'No categories found for the selected type';

  @override
  String get manageTags => 'Manage Tags';

  @override
  String get addTag => 'Add Tag';

  @override
  String get editTag => 'Edit Tag';

  @override
  String get tagName => 'Tag Name';

  @override
  String get tagNameHint => 'Enter tag name';

  @override
  String get deleteTag => 'Delete Tag';

  @override
  String get deleteTagConfirmTitle => 'Delete Tag?';

  @override
  String get deleteTagConfirmBody =>
      'Are you sure you want to delete this tag? This action cannot be undone.';

  @override
  String get removeTagFromTransactions => 'Remove form usage';

  @override
  String get tagDeleted => 'Tag deleted';

  @override
  String get tagSaved => 'Tag saved';

  @override
  String get fieldRequired => 'Required';

  @override
  String get transactionInstallmentsLabel => 'Number of Installments';

  @override
  String get transactionInstallmentsHelper =>
      'Split this expense into multiple monthly installments';

  @override
  String get transactionIsLinked => 'This is part of an installment plan';

  @override
  String get transactionLinkedToParent => 'Linked to parent transaction';

  @override
  String transactionHasChildren(int count) {
    return 'This transaction has $count linked installments';
  }

  @override
  String get editParentTransactionMessage =>
      'You must edit the parent transaction. Changes will be applied to all installments.';

  @override
  String get transactionNotFound => 'Transaction not found';
}
