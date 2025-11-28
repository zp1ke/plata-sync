import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A centralized collection of application icons.
/// HugeIcons are used: https://hugeicons.com/icons?style=Stroke&type=Rounded
class AppIcons {
  // Private constructor to prevent instantiation
  const AppIcons._();

  // Actions
  static final add = HugeIcon(icon: HugeIcons.strokeRoundedAdd01);
  static final clear = HugeIcon(icon: HugeIcons.strokeRoundedCancel01);
  static final copy = HugeIcon(icon: HugeIcons.strokeRoundedCopy01);
  static final edit = HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02);
  static final delete = HugeIcon(icon: HugeIcons.strokeRoundedDelete04);
  static final refresh = HugeIcon(icon: HugeIcons.strokeRoundedRefresh);
  static final search = HugeIcon(icon: HugeIcons.strokeRoundedSearch01);
  static final searchXs = HugeIcon(
    icon: HugeIcons.strokeRoundedSearch01,
    size: AppSizing.iconXs,
  );
  static final searchOff = HugeIcon(icon: HugeIcons.strokeRoundedSearchRemove);
  static final sort = HugeIcon(icon: HugeIcons.strokeRoundedSorting01);
  static final sortAscending = HugeIcon(
    icon: HugeIcons.strokeRoundedSortByUp02,
  );
  static final sortDescending = HugeIcon(
    icon: HugeIcons.strokeRoundedSortByDown02,
  );
  static final viewList = HugeIcon(icon: HugeIcons.strokeRoundedMenu01);
  static final viewGrid = HugeIcon(icon: HugeIcons.strokeRoundedGridView);

  // Transactions
  static final transactions = HugeIcon(icon: HugeIcons.strokeRoundedInvoice);
  static final transactionsOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedInvoice,
  );

  // Accounts
  static final accounts = HugeIcon(icon: HugeIcons.strokeRoundedWallet02);
  static final accountsOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedWallet02,
  );

  // Categories
  static final categories = HugeIcon(
    icon: HugeIcons.strokeRoundedFolderLibrary,
  );
  static final categoriesOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedFolderLibrary,
  );

  // Settings
  static final settings = HugeIcon(icon: HugeIcons.strokeRoundedSettings01);
  static final settingsOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedSettings01,
  );
  static final info = HugeIcon(icon: HugeIcons.strokeRoundedInformationCircle);
  static final database = HugeIcon(icon: HugeIcons.strokeRoundedDatabase01);
  static final memory = HugeIcon(icon: HugeIcons.strokeRoundedCpuCharge);

  // Others
  static final arrowDropDown = HugeIcon(
    icon: HugeIcons.strokeRoundedArrowDown01,
  );
  static final arrowDropUp = HugeIcon(icon: HugeIcons.strokeRoundedArrowUp01);

  static Widget getIcon(String name, {Color? color, double? size}) {
    final iconData = iconDataMap[name] ?? HugeIcons.strokeRoundedHelpCircle;
    return HugeIcon(icon: iconData, color: color, size: size);
  }

  static String getIconLabel(String name, AppL10n l10n) {
    switch (name) {
      case 'account_balance':
        return l10n.iconAccountBalance;
      case 'savings':
        return l10n.iconSavings;
      case 'credit_card':
        return l10n.iconCreditCard;
      case 'payments':
        return l10n.iconPayments;
      case 'shopping_cart':
        return l10n.iconShoppingCart;
      case 'bolt':
        return l10n.iconBolt;
      case 'movie':
        return l10n.iconMovie;
      case 'restaurant':
        return l10n.iconRestaurant;
      case 'home':
        return l10n.iconHome;
      case 'car':
        return l10n.iconCar;
      case 'flight':
        return l10n.iconFlight;
      case 'gift':
        return l10n.iconGift;
      case 'medical':
        return l10n.iconMedical;
      case 'education':
        return l10n.iconEducation;
      case 'entertainment':
        return l10n.iconEntertainment;
      case 'travel':
        return l10n.iconTravel;
      case 'fitness':
        return l10n.iconFitness;
      case 'coffee':
        return l10n.iconCoffee;
      case 'shopping_bag':
        return l10n.iconShoppingBag;
      case 'music':
        return l10n.iconMusic;
      case 'pets':
        return l10n.iconPets;
      case 'transportation':
        return l10n.iconTransportation;
      case 'food':
        return l10n.iconFood;
      case 'clothing':
        return l10n.iconClothing;
      case 'health':
        return l10n.iconHealth;
      case 'salary':
        return l10n.iconSalary;
      case 'flash_on':
        return l10n.iconFlashOn;
      default:
        return l10n.iconUnknown;
    }
  }

  // Map for dynamic icon retrieval by name
  static final Map<String, dynamic> iconDataMap = {
    'account_balance': HugeIcons.strokeRoundedBank,
    'savings': HugeIcons.strokeRoundedMoneySavingJar,
    'credit_card': HugeIcons.strokeRoundedCreditCard,
    'payments': HugeIcons.strokeRoundedCashback,
    'shopping_cart': HugeIcons.strokeRoundedShoppingCart01,
    'bolt': HugeIcons.strokeRoundedFlashOff,
    'movie': HugeIcons.strokeRoundedVideo01,
    'restaurant': HugeIcons.strokeRoundedRestaurant02,
    'home': HugeIcons.strokeRoundedHome01,
    'car': HugeIcons.strokeRoundedCar01,
    'flight': HugeIcons.strokeRoundedAirplaneModeOff,
    'gift': HugeIcons.strokeRoundedGift,
    'medical': HugeIcons.strokeRoundedMedicalMask,
    'education': HugeIcons.strokeRoundedBook01,
    'entertainment': HugeIcons.strokeRoundedGameController01,
    'travel': HugeIcons.strokeRoundedMaps,
    'fitness': HugeIcons.strokeRoundedRunningShoes,
    'coffee': HugeIcons.strokeRoundedCoffee01,
    'shopping_bag': HugeIcons.strokeRoundedShoppingBag01,
    'music': HugeIcons.strokeRoundedMusicNote01,
    'pets': HugeIcons.strokeRoundedFavourite,
    'transportation': HugeIcons.strokeRoundedBus01,
    'food': HugeIcons.strokeRoundedApple,
    'clothing': HugeIcons.strokeRoundedTShirt,
    'health': HugeIcons.strokeRoundedHospital01,
    'salary': HugeIcons.strokeRoundedMoney02,
    'flash_on': HugeIcons.strokeRoundedFlash,
  };
}
