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

  /// Title of the Accounts screen
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsScreenTitle;

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

  /// Text displayed in the body of the Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings Screen'**
  String get settingsScreenBody;

  /// Message shown when there are no categories
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get categoriesEmptyState;

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
  /// **'Icon'**
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

  /// Label for unknown icon
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get iconUnknown;
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
