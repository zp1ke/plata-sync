import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Plata Sync'**
  String get appTitle;

  /// Label for the Transactions navigation tab
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// Label for the Accounts navigation tab
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// Title of the Transactions screen
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsScreenTitle;

  /// Text displayed in the body of the Transactions screen
  ///
  /// In en, this message translates to:
  /// **'Transactions Screen'**
  String get transactionsScreenBody;

  /// Button label to add a new transaction
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get transactionsAddButton;

  /// Title of the Accounts screen
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsScreenTitle;

  /// Hint text for account search field
  ///
  /// In en, this message translates to:
  /// **'Search accounts...'**
  String get accountsSearchHint;

  /// Message shown when there are no accounts
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get accountsEmptyState;

  /// Message shown when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No accounts found for \"{query}\"'**
  String accountsNoSearchResults(String query);

  /// Prompt shown in detail pane when no account is selected
  ///
  /// In en, this message translates to:
  /// **'Select an account to view details'**
  String get accountsSelectPrompt;

  /// Label for add account button
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get accountsAddButton;

  /// Prompt to add sample accounts
  ///
  /// In en, this message translates to:
  /// **'Would you like to add some sample accounts to get started?'**
  String get accountsAddSampleDataPrompt;

  /// Sort accounts by name ascending
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get accountsSortNameAsc;

  /// Sort accounts by name descending
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get accountsSortNameDesc;

  /// Sort accounts by last used ascending
  ///
  /// In en, this message translates to:
  /// **'Last Used (Oldest)'**
  String get accountsSortLastUsedAsc;

  /// Sort accounts by last used descending
  ///
  /// In en, this message translates to:
  /// **'Last Used (Recent)'**
  String get accountsSortLastUsedDesc;

  /// Sort accounts by balance ascending
  ///
  /// In en, this message translates to:
  /// **'Balance (Low to High)'**
  String get accountsSortBalanceAsc;

  /// Sort accounts by balance descending
  ///
  /// In en, this message translates to:
  /// **'Balance (High to Low)'**
  String get accountsSortBalanceDesc;

  /// Success message when account is created
  ///
  /// In en, this message translates to:
  /// **'Account \"{name}\" created'**
  String accountCreated(String name);

  /// Error message when account creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create account: {error}'**
  String accountCreateFailed(String error);

  /// Success message when account is updated
  ///
  /// In en, this message translates to:
  /// **'Account \"{name}\" updated'**
  String accountUpdated(String name);

  /// Error message when account update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update account: {error}'**
  String accountUpdateFailed(String error);

  /// Success message when account is deleted
  ///
  /// In en, this message translates to:
  /// **'Account \"{name}\" deleted'**
  String accountDeleted(String name);

  /// Error message when account deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account \"{name}\": {error}'**
  String accountDeleteFailed(String name, String error);

  /// Confirmation message when deleting an account
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String accountsDeleteConfirmation(String name);

  /// Success message when account is duplicated
  ///
  /// In en, this message translates to:
  /// **'Account \"{name}\" duplicated'**
  String accountDuplicated(String name);

  /// Error message when account duplication fails
  ///
  /// In en, this message translates to:
  /// **'Failed to duplicate account \"{name}\": {error}'**
  String accountDuplicateFailed(String name, String error);

  /// Text displayed in the body of the Accounts screen
  ///
  /// In en, this message translates to:
  /// **'Accounts Screen'**
  String get accountsScreenBody;

  /// Label for the Categories navigation tab
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// Title of the Categories screen
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesScreenTitle;

  /// Text displayed in the body of the Categories screen
  ///
  /// In en, this message translates to:
  /// **'Categories Screen'**
  String get categoriesScreenBody;

  /// Hint text for the Categories search field
  ///
  /// In en, this message translates to:
  /// **'Search Categories'**
  String get categoriesSearchHint;

  /// Prompt asking the user if they want to add sample categories
  ///
  /// In en, this message translates to:
  /// **'Would you like to add sample categories to get started?'**
  String get categoriesAddSampleDataPrompt;

  /// Label for the Settings navigation tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Title of the Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// Section header for app settings
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsSectionApp;

  /// Section header for data settings
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// Label for export data action
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportData;

  /// Description for export data action
  ///
  /// In en, this message translates to:
  /// **'Export all your data to a JSON backup file'**
  String get settingsExportDataDesc;

  /// Message shown when export starts on web
  ///
  /// In en, this message translates to:
  /// **'Export started. Check your downloads.'**
  String get settingsExportStarted;

  /// Message shown when export completes
  ///
  /// In en, this message translates to:
  /// **'Export complete.'**
  String get settingsExportSuccess;

  /// Message shown when export fails
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String settingsExportFailed(String error);

  /// Label for import data action
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get settingsImportData;

  /// Description for import data action
  ///
  /// In en, this message translates to:
  /// **'Import data from a JSON backup file'**
  String get settingsImportDataDesc;

  /// Message shown when import succeeds
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get settingsImportSuccess;

  /// Message shown when import fails
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String settingsImportFailed(String error);

  /// Title for import mode selection dialog
  ///
  /// In en, this message translates to:
  /// **'Import Mode'**
  String get settingsImportModeTitle;

  /// Label for append import mode
  ///
  /// In en, this message translates to:
  /// **'Append'**
  String get settingsImportModeAppend;

  /// Description for append import mode
  ///
  /// In en, this message translates to:
  /// **'Add imported data to existing data'**
  String get settingsImportModeAppendDesc;

  /// Label for replace import mode
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get settingsImportModeReplace;

  /// Description for replace import mode
  ///
  /// In en, this message translates to:
  /// **'Delete all existing data and replace with imported data'**
  String get settingsImportModeReplaceDesc;

  /// Label for clear data action
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get settingsClearData;

  /// Description for clear data action
  ///
  /// In en, this message translates to:
  /// **'Delete all accounts, categories, tags, and transactions'**
  String get settingsClearDataDesc;

  /// Title for clear data confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Clear All Data?'**
  String get settingsClearDataConfirmTitle;

  /// Message for clear data confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your accounts, categories, tags, and transactions. This action cannot be undone.'**
  String get settingsClearDataConfirmMessage;

  /// Message shown when clear data succeeds
  ///
  /// In en, this message translates to:
  /// **'All data cleared successfully'**
  String get settingsClearDataSuccess;

  /// Message shown when clear data fails
  ///
  /// In en, this message translates to:
  /// **'Failed to clear data: {error}'**
  String settingsClearDataFailed(String error);

  /// Section header for display settings
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsSectionDisplay;

  /// Label for app version setting
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsAppVersion;

  /// Label for open source licenses button
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsLicenses;

  /// Label for data source setting
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get settingsDataSource;

  /// Label for in-memory data source option
  ///
  /// In en, this message translates to:
  /// **'In-Memory'**
  String get settingsDataSourceInMemory;

  /// Description for in-memory data source option
  ///
  /// In en, this message translates to:
  /// **'Data is stored temporarily and will be lost when the app closes'**
  String get settingsDataSourceInMemoryDesc;

  /// Label for local database data source option
  ///
  /// In en, this message translates to:
  /// **'Local Database'**
  String get settingsDataSourceLocal;

  /// Description for local database data source option
  ///
  /// In en, this message translates to:
  /// **'Data is stored persistently in a local SQLite database'**
  String get settingsDataSourceLocalDesc;

  /// Title for data source change confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Change Data Source?'**
  String get settingsDataSourceChangeTitle;

  /// Message for data source change confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Changing the data source will require an app restart. Your current data will not be transferred automatically between different data sources.'**
  String get settingsDataSourceChangeMessage;

  /// Title for data source changed notification
  ///
  /// In en, this message translates to:
  /// **'Data Source Changed'**
  String get settingsDataSourceChangedTitle;

  /// Title for restart notification after data source change
  ///
  /// In en, this message translates to:
  /// **'Restarting App'**
  String get restartingApp;

  /// Message for restart notification after data source change and during restart
  ///
  /// In en, this message translates to:
  /// **'The data source has been changed. Restarting the app to apply changes.'**
  String get settingsDataSourceChangedRestartingMessage;

  /// Message for restart notification after data source change
  ///
  /// In en, this message translates to:
  /// **'The data source has been changed. Please restart the app to apply changes.'**
  String get settingsDataSourceChangedMessage;

  /// Label for long date format option
  ///
  /// In en, this message translates to:
  /// **'Long Date Format'**
  String get settingsDateFormatLong;

  /// Example for long date format
  ///
  /// In en, this message translates to:
  /// **'e.g., December 2, 2025'**
  String get settingsDateFormatLongExample;

  /// Label for short date format option
  ///
  /// In en, this message translates to:
  /// **'Short Date Format'**
  String get settingsDateFormatShort;

  /// Example for short date format
  ///
  /// In en, this message translates to:
  /// **'e.g., 12/2/2025'**
  String get settingsDateFormatShortExample;

  /// Label for 12-hour time format option
  ///
  /// In en, this message translates to:
  /// **'12-Hour Time'**
  String get settingsTimeFormat12h;

  /// Example for 12-hour time format
  ///
  /// In en, this message translates to:
  /// **'e.g., 2:30 PM'**
  String get settingsTimeFormat12hExample;

  /// Label for 24-hour time format option
  ///
  /// In en, this message translates to:
  /// **'24-Hour Time'**
  String get settingsTimeFormat24h;

  /// Example for 24-hour time format
  ///
  /// In en, this message translates to:
  /// **'e.g., 14:30'**
  String get settingsTimeFormat24hExample;

  /// Message shown when there are no categories
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get categoriesEmptyState;

  /// Prompt shown in detail pane when no category is selected
  ///
  /// In en, this message translates to:
  /// **'Select a category to view details'**
  String get categoriesSelectPrompt;

  /// Label for last used date field
  ///
  /// In en, this message translates to:
  /// **'Last Used'**
  String get categoriesLastUsed;

  /// Message shown when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String categoriesNoSearchResults(String query);

  /// Sort categories by name ascending
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get categoriesSortNameAsc;

  /// Sort categories by name descending
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get categoriesSortNameDesc;

  /// Sort categories by last used ascending
  ///
  /// In en, this message translates to:
  /// **'Last Used (Oldest)'**
  String get categoriesSortLastUsedAsc;

  /// Sort categories by last used descending
  ///
  /// In en, this message translates to:
  /// **'Last Used (Newest)'**
  String get categoriesSortLastUsedDesc;

  /// Title for category filter dialog
  ///
  /// In en, this message translates to:
  /// **'Filter Categories'**
  String get filterCategories;

  /// Label for category type filter
  ///
  /// In en, this message translates to:
  /// **'Category Type'**
  String get categoryTypeFilter;

  /// Label for all category types filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryTypeAll;

  /// Label for income category type
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryTypeIncome;

  /// Label for expense category type
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get categoryTypeExpense;

  /// Tooltip for list view
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get viewList;

  /// Tooltip for grid view
  ///
  /// In en, this message translates to:
  /// **'Grid View'**
  String get viewGrid;

  /// Affirmative response
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative response
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Acknowledgment response
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Label indicating a field is optional
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Duplicate action
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// Label for account ID field
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get accountsDetailsId;

  /// Label for account balance field
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get accountsDetailsBalance;

  /// Label for account created at field
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get accountsDetailsCreatedAt;

  /// Label for account last used field
  ///
  /// In en, this message translates to:
  /// **'Last Used'**
  String get accountsDetailsLastUsed;

  /// Label for account enabled status field
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get accountsDetailsEnabled;

  /// Action to view transactions filtered by account
  ///
  /// In en, this message translates to:
  /// **'View Transactions'**
  String get accountsViewTransactions;

  /// Title for account edit dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get accountsEditTitle;

  /// Title for account create dialog
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get accountsCreateTitle;

  /// Label for account name field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountsEditName;

  /// Validation message when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get accountsEditNameRequired;

  /// Label for account description field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountsEditDescription;

  /// Label for account initial balance field
  ///
  /// In en, this message translates to:
  /// **'Initial Balance'**
  String get accountsEditInitialBalance;

  /// Helper text for initial balance field
  ///
  /// In en, this message translates to:
  /// **'Enter the starting balance for this account'**
  String get accountsEditInitialBalanceHelper;

  /// Validation message when initial balance is empty
  ///
  /// In en, this message translates to:
  /// **'Initial balance is required'**
  String get accountsEditInitialBalanceRequired;

  /// Validation message when initial balance format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid amount format'**
  String get accountsEditInitialBalanceInvalid;

  /// Label for account icon field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Account Icon'**
  String get accountsEditIcon;

  /// Validation message when icon is empty
  ///
  /// In en, this message translates to:
  /// **'Icon is required'**
  String get accountsEditIconRequired;

  /// Label for background color field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get accountsEditBackgroundColor;

  /// Label for icon color field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Icon Color'**
  String get accountsEditIconColor;

  /// Label for supports effective date toggle in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Supports Effective Date'**
  String get accountsEditSupportsEffectiveDate;

  /// Helper text explaining effective date support
  ///
  /// In en, this message translates to:
  /// **'Allow transactions to have a future effective date'**
  String get accountsEditSupportsEffectiveDateHelper;

  /// Label for supports installments toggle in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Supports Installments'**
  String get accountsEditSupportsInstallments;

  /// Helper text explaining installments support
  ///
  /// In en, this message translates to:
  /// **'Allow expense transactions to be split into multiple installments'**
  String get accountsEditSupportsInstallmentsHelper;

  /// Label for account enabled switch in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get accountsEditEnabled;

  /// Helper text for account enabled switch
  ///
  /// In en, this message translates to:
  /// **'Disabled accounts appear last and won\'t show in selectors.'**
  String get accountsEditEnabledHelper;

  /// Label for category ID field
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get categoriesDetailsId;

  /// Label for category last used field
  ///
  /// In en, this message translates to:
  /// **'Last Used'**
  String get categoriesDetailsLastUsed;

  /// Label for category icon field
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get categoriesDetailsIcon;

  /// Label for category background color field
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get categoriesDetailsBackgroundColor;

  /// Label for category icon color field
  ///
  /// In en, this message translates to:
  /// **'Icon Color'**
  String get categoriesDetailsIconColor;

  /// Label for category enabled status field
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get categoriesDetailsEnabled;

  /// Label for copy action
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Message shown when a category is duplicated successfully
  ///
  /// In en, this message translates to:
  /// **'Category \"{categoryName}\" duplicated successfully.'**
  String categoryDuplicated(String categoryName);

  /// Message shown when duplicating a category fails
  ///
  /// In en, this message translates to:
  /// **'Failed to duplicate category \"{categoryName}\": {error}'**
  String categoryDuplicateFailed(String categoryName, String error);

  /// Confirmation message for deleting a category
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{categoryName}\"?'**
  String categoriesDeleteConfirmation(String categoryName);

  /// Message shown when a category is deleted successfully
  ///
  /// In en, this message translates to:
  /// **'Category \"{categoryName}\" deleted successfully.'**
  String categoryDeleted(String categoryName);

  /// Message shown when deleting a category fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category \"{categoryName}\": {error}'**
  String categoryDeleteFailed(String categoryName, String error);

  /// Indicates that something has never occurred
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// Label for category created at field
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get categoriesDetailsCreatedAt;

  /// Action to view transactions for a specific category
  ///
  /// In en, this message translates to:
  /// **'View Transactions'**
  String get categoriesDetailsViewTransactions;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Title for icon editor dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Icon'**
  String get editIcon;

  /// Title for category edit dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get categoriesEditTitle;

  /// Title for category create dialog
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get categoriesCreateTitle;

  /// Label for category name field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get categoriesEditName;

  /// Validation message when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get categoriesEditNameRequired;

  /// Label for category description field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get categoriesEditDescription;

  /// Label for category icon field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Category Icon'**
  String get categoriesEditIcon;

  /// Helper text for icon field
  ///
  /// In en, this message translates to:
  /// **'e.g., shopping_cart, bolt, movie'**
  String get categoriesEditIconHelper;

  /// Validation message when icon is empty
  ///
  /// In en, this message translates to:
  /// **'Icon is required'**
  String get categoriesEditIconRequired;

  /// Label for background color field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get categoriesEditBackgroundColor;

  /// Label for icon color field in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Icon Color'**
  String get categoriesEditIconColor;

  /// Helper text for color fields
  ///
  /// In en, this message translates to:
  /// **'Hex color (e.g., #FF5733 or FF5733)'**
  String get categoriesEditColorHelper;

  /// Validation message when color is empty
  ///
  /// In en, this message translates to:
  /// **'Color is required'**
  String get categoriesEditColorRequired;

  /// Validation message when color format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid hex color format'**
  String get categoriesEditColorInvalid;

  /// Label for transaction type field in category edit dialog
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get categoriesEditTransactionType;

  /// Helper text for transaction type field
  ///
  /// In en, this message translates to:
  /// **'Leave \'Any\' to allow for both \'Income\' and \'Expense\''**
  String get categoriesEditTransactionTypeHelper;

  /// Label for category enabled switch in edit dialog
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get categoriesEditEnabled;

  /// Helper text for category enabled switch
  ///
  /// In en, this message translates to:
  /// **'Disabled categories appear last and won\'t show in selectors.'**
  String get categoriesEditEnabledHelper;

  /// Label for income transaction type in category form
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryTransactionTypeIncome;

  /// Label for expense transaction type in category form
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get categoryTransactionTypeExpense;

  /// Label for any transaction type in category form (when null)
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get categoryTransactionTypeAny;

  /// Label for the add category button
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get categoriesAddButton;

  /// Message shown when a category is created successfully
  ///
  /// In en, this message translates to:
  /// **'Category \"{categoryName}\" created successfully.'**
  String categoryCreated(String categoryName);

  /// Message shown when creating a category fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create category: {error}'**
  String categoryCreateFailed(String error);

  /// Message shown when a category is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Category \"{categoryName}\" updated successfully.'**
  String categoryUpdated(String categoryName);

  /// Message shown when updating a category fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update category: {error}'**
  String categoryUpdateFailed(String error);

  /// Label for shopping cart icon
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get iconShoppingCart;

  /// Label for bolt icon
  ///
  /// In en, this message translates to:
  /// **'Bolt'**
  String get iconBolt;

  /// Label for movie icon
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get iconMovie;

  /// Label for restaurant icon
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get iconRestaurant;

  /// Label for home icon
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get iconHome;

  /// Label for car icon
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get iconCar;

  /// Label for flight icon
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get iconFlight;

  /// Label for gift icon
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get iconGift;

  /// Label for medical icon
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get iconMedical;

  /// Label for education icon
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get iconEducation;

  /// Label for entertainment icon
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get iconEntertainment;

  /// Label for travel icon
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get iconTravel;

  /// Label for fitness icon
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get iconFitness;

  /// Label for coffee icon
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get iconCoffee;

  /// Label for shopping bag icon
  ///
  /// In en, this message translates to:
  /// **'Shopping Bag'**
  String get iconShoppingBag;

  /// Label for music icon
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get iconMusic;

  /// Label for pets icon
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get iconPets;

  /// Label for transportation icon
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get iconTransportation;

  /// Label for food icon
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get iconFood;

  /// Label for clothing icon
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get iconClothing;

  /// Label for health icon
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get iconHealth;

  /// Label for salary icon
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get iconSalary;

  /// Label for flash on icon
  ///
  /// In en, this message translates to:
  /// **'Flash On'**
  String get iconFlashOn;

  /// Label for account balance icon
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get iconAccountBalance;

  /// Label for savings icon
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get iconSavings;

  /// Label for credit card icon
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get iconCreditCard;

  /// Label for payments icon
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get iconPayments;

  /// Label for unknown icon
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get iconUnknown;

  /// Generic label for unknown entity
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Default search hint for select field widget
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get selectFieldSearchHint;

  /// Message shown when select field search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get selectFieldNoResults;

  /// Label for no selection or empty option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Cancel button text for select field dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get selectFieldCancel;

  /// Label for expense transaction type
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionTypeExpense;

  /// Label for income transaction type
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionTypeIncome;

  /// Label for transfer transaction type
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transactionTypeTransfer;

  /// Label for transaction date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDateLabel;

  /// Label for transaction effective date field
  ///
  /// In en, this message translates to:
  /// **'Effective Date'**
  String get transactionEffectiveDateLabel;

  /// Format for displaying transaction date
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String transactionDateFormat(DateTime date);

  /// Label for account field in transaction form
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get transactionAccountLabel;

  /// Label for source account field in transfer transaction
  ///
  /// In en, this message translates to:
  /// **'Source Account'**
  String get transactionSourceAccountLabel;

  /// Label for target account field in transfer transaction
  ///
  /// In en, this message translates to:
  /// **'Target Account'**
  String get transactionTargetAccountLabel;

  /// Label for category field in transaction form
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionCategoryLabel;

  /// Date filter option for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateFilterToday;

  /// Date filter option for this week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dateFilterWeek;

  /// Date filter option for this month
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get dateFilterMonth;

  /// Date filter option for all time
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get dateFilterAll;

  /// Title for transaction filter dialog
  ///
  /// In en, this message translates to:
  /// **'Filter Transactions'**
  String get filterTransactions;

  /// Label for transaction type filter
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionTypeFilter;

  /// Label for all transaction types filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get transactionTypeAll;

  /// Hint for account selection
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get selectAccount;

  /// Hint for account search
  ///
  /// In en, this message translates to:
  /// **'Search accounts...'**
  String get searchAccounts;

  /// Hint for category selection
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// Hint for category search
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategories;

  /// Hint for category selection in multi-select
  ///
  /// In en, this message translates to:
  /// **'Select Categories'**
  String get selectCategories;

  /// Hint for account selection in multi-select
  ///
  /// In en, this message translates to:
  /// **'Select Accounts'**
  String get selectAccounts;

  /// Hint for tag selection
  ///
  /// In en, this message translates to:
  /// **'Select Tags'**
  String get selectTags;

  /// Hint for tag search
  ///
  /// In en, this message translates to:
  /// **'Search tags...'**
  String get searchTags;

  /// Label for clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Label for apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Validation message when account is not selected
  ///
  /// In en, this message translates to:
  /// **'Account is required'**
  String get transactionAccountRequired;

  /// Validation message when target account is not selected for transfer
  ///
  /// In en, this message translates to:
  /// **'Target account is required'**
  String get transactionTargetAccountRequired;

  /// Validation message when target account is same as source account
  ///
  /// In en, this message translates to:
  /// **'Target account must be different from source account'**
  String get transactionTargetAccountSameError;

  /// Label for transaction amount field
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionAmountLabel;

  /// Validation message when amount is not entered
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get transactionAmountRequired;

  /// Validation message when amount is zero or negative
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get transactionAmountMustBePositive;

  /// Label for transaction notes field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get transactionNotesLabel;

  /// Hint text for transaction notes field
  ///
  /// In en, this message translates to:
  /// **'Add optional notes'**
  String get transactionNotesHint;

  /// Text for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Title for create transaction dialog
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get transactionCreateTitle;

  /// Title for edit transaction dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get transactionEditTitle;

  /// Label for transaction ID field
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionIdLabel;

  /// Message shown when there are no transactions
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactionsEmptyState;

  /// Message shown when there are no transactions matching the current filters
  ///
  /// In en, this message translates to:
  /// **'No transactions found with current filters'**
  String get transactionsEmptyFilteredState;

  /// Message shown when there are no transactions matching the current date filter
  ///
  /// In en, this message translates to:
  /// **'No transactions found for {dateFilter}'**
  String transactionsEmptyDateFilteredState(String dateFilter);

  /// Prompt shown in detail pane when no transaction is selected
  ///
  /// In en, this message translates to:
  /// **'Select a transaction to view details'**
  String get transactionsSelectPrompt;

  /// Prompt to add sample transactions
  ///
  /// In en, this message translates to:
  /// **'Would you like to add some sample transactions to get started?'**
  String get transactionsAddSampleDataPrompt;

  /// Sort transactions by date ascending
  ///
  /// In en, this message translates to:
  /// **'Date (Oldest First)'**
  String get transactionsSortDateAsc;

  /// Sort transactions by date descending
  ///
  /// In en, this message translates to:
  /// **'Date (Newest First)'**
  String get transactionsSortDateDesc;

  /// Sort transactions by amount ascending
  ///
  /// In en, this message translates to:
  /// **'Amount (Low to High)'**
  String get transactionsSortAmountAsc;

  /// Sort transactions by amount descending
  ///
  /// In en, this message translates to:
  /// **'Amount (High to Low)'**
  String get transactionsSortAmountDesc;

  /// Success message when transaction is created
  ///
  /// In en, this message translates to:
  /// **'Transaction created'**
  String get transactionCreated;

  /// Error message when transaction creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create transaction: {error}'**
  String transactionCreateFailed(String error);

  /// Success message when transaction is updated
  ///
  /// In en, this message translates to:
  /// **'Transaction updated'**
  String get transactionUpdated;

  /// Error message when transaction update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update transaction: {error}'**
  String transactionUpdateFailed(String error);

  /// Success message when transaction is deleted
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// Error message when transaction deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete transaction: {error}'**
  String transactionDeleteFailed(String error);

  /// Confirmation message when deleting a transaction
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get transactionsDeleteConfirmation;

  /// Button text to add sample data
  ///
  /// In en, this message translates to:
  /// **'Add Sample Data'**
  String get addSampleData;

  /// Success message when sample data is created
  ///
  /// In en, this message translates to:
  /// **'Sample data created successfully'**
  String get sampleDataCreated;

  /// Error message when sample data creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create sample data: {error}'**
  String sampleDataCreateFailed(String error);

  /// Title for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Refresh action tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Label for transfer icon
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get iconTransfer;

  /// Label for balance movement field in transaction form
  ///
  /// In en, this message translates to:
  /// **'Balance Movement'**
  String get transactionBalanceMovementLabel;

  /// Label for tags field in transaction form
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get transactionTagsLabel;

  /// Hint text for transaction tags field
  ///
  /// In en, this message translates to:
  /// **'Add tags...'**
  String get transactionTagsHint;

  /// Label for add button in transaction tags field
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Error message when creating a tag fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create tag: {error}'**
  String errorCreatingTagMessage(String error);

  /// Label for done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Generic validation message when a required field is empty
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequiredError;

  /// Generic validation message when amount format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid amount format'**
  String get invalidAmountError;

  /// Label for go action
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// Label for search action
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Label for send action
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Label for next action
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Message shown when no categories match the selected type filter
  ///
  /// In en, this message translates to:
  /// **'No categories found for the selected type'**
  String get categoriesNoTypeFilterResults;

  /// Label for manage tags action
  ///
  /// In en, this message translates to:
  /// **'Manage Tags'**
  String get manageTags;

  /// Title for add tag dialog
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get addTag;

  /// Title for edit tag dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Tag'**
  String get editTag;

  /// Label for tag name field
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tagName;

  /// Hint text for tag name field
  ///
  /// In en, this message translates to:
  /// **'Enter tag name'**
  String get tagNameHint;

  /// Label for delete tag action
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get deleteTag;

  /// Title for delete tag confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete Tag?'**
  String get deleteTagConfirmTitle;

  /// Body for delete tag confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this tag? This action cannot be undone.'**
  String get deleteTagConfirmBody;

  /// Checkbox label to remove tag from associated transactions
  ///
  /// In en, this message translates to:
  /// **'Remove form usage'**
  String get removeTagFromTransactions;

  /// Success message when tag is deleted
  ///
  /// In en, this message translates to:
  /// **'Tag deleted'**
  String get tagDeleted;

  /// Success message when tag is saved
  ///
  /// In en, this message translates to:
  /// **'Tag saved'**
  String get tagSaved;

  /// Short required field message
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// Label for transaction installments field
  ///
  /// In en, this message translates to:
  /// **'Number of Installments'**
  String get transactionInstallmentsLabel;

  /// Helper text for installments field
  ///
  /// In en, this message translates to:
  /// **'Split this expense into multiple monthly installments'**
  String get transactionInstallmentsHelper;

  /// Validation error for installments field
  ///
  /// In en, this message translates to:
  /// **'Number of installments must be between 1 and 24'**
  String get transactionInstallmentsValidation;

  /// Info shown when viewing a transaction that is linked to a parent
  ///
  /// In en, this message translates to:
  /// **'This is part of an installment plan'**
  String get transactionIsLinked;

  /// Info shown when a transaction is linked
  ///
  /// In en, this message translates to:
  /// **'Linked to parent transaction'**
  String get transactionLinkedToParent;

  /// Info shown when viewing a parent transaction with linked children
  ///
  /// In en, this message translates to:
  /// **'This transaction has {count} linked installments'**
  String transactionHasChildren(int count);

  /// Message shown when trying to edit a linked transaction
  ///
  /// In en, this message translates to:
  /// **'You must edit the parent transaction. Changes will be applied to all installments.'**
  String get editParentTransactionMessage;

  /// Error message when a transaction cannot be found
  ///
  /// In en, this message translates to:
  /// **'Transaction not found'**
  String get transactionNotFound;

  /// Tooltip for increase/add button
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// Tooltip for decrease/remove button
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
