import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../l10n/app_localizations.dart';
import 'app_colors.dart';
import 'app_sizing.dart';

/// A centralized collection of application icons.
/// HugeIcons are used: https://hugeicons.com/icons?style=Stroke&type=Rounded
class AppIcons {
  // Private constructor to prevent instantiation
  const AppIcons._();

  // App Icon
  static Widget appIcon(
    BuildContext context, {
    double size = AppSizing.iconMd,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return SvgPicture(
      AssetBytesLoader(
        'assets/icons/app_icon_${colorScheme.brightness.name}.svg.vec',
      ),
      width: size,
      height: size,
      placeholderBuilder: (context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.appIconGradientStart,
              colorScheme.appIconGradientEnd,
            ],
          ),
        ),
        child: Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedWallet01,
            size: size * 0.5,
            color: colorScheme.inAppIcon,
          ),
        ),
      ),
    );
  }

  // Actions
  static final add = const HugeIcon(icon: HugeIcons.strokeRoundedAdd01);
  static final clear = const HugeIcon(icon: HugeIcons.strokeRoundedCancel01);
  static final close = const HugeIcon(
    icon: HugeIcons.strokeRoundedCancelSquare,
  );
  static final copy = const HugeIcon(icon: HugeIcons.strokeRoundedCopy01);
  static final edit = const HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02);
  static Widget editSm({required Color color}) => HugeIcon(
    icon: HugeIcons.strokeRoundedPencilEdit02,
    size: AppSizing.iconSm,
    color: color,
  );
  static final delete = const HugeIcon(icon: HugeIcons.strokeRoundedDelete04);
  static final backDelete = const Icon(Icons.backspace);
  static final refresh = const HugeIcon(icon: HugeIcons.strokeRoundedRefresh);
  static final go = const HugeIcon(icon: HugeIcons.strokeRoundedThumbsUp);
  static final send = const HugeIcon(icon: HugeIcons.strokeRoundedSent);
  static final download = const HugeIcon(
    icon: HugeIcons.strokeRoundedDownload01,
  );
  static final search = const HugeIcon(icon: HugeIcons.strokeRoundedSearch01);
  static final searchXs = const HugeIcon(
    icon: HugeIcons.strokeRoundedSearch01,
    size: AppSizing.iconXs,
  );
  static final searchOff = const HugeIcon(
    icon: HugeIcons.strokeRoundedSearchRemove,
  );
  static final sort = const HugeIcon(icon: HugeIcons.strokeRoundedSorting01);
  static final sortAscending = const HugeIcon(
    icon: HugeIcons.strokeRoundedSortByUp02,
  );
  static final sortDescending = const HugeIcon(
    icon: HugeIcons.strokeRoundedSortByDown02,
  );
  static final filter = HugeIcon(icon: HugeIcons.strokeRoundedFilter);
  static final filterEdit = HugeIcon(icon: HugeIcons.strokeRoundedFilterEdit);
  static final viewList = const HugeIcon(icon: HugeIcons.strokeRoundedMenu01);
  static final viewGrid = const HugeIcon(icon: HugeIcons.strokeRoundedGridView);

  // Transactions
  static final transactions = const HugeIcon(
    icon: HugeIcons.strokeRoundedInvoice,
  );
  static final transactionsOutlined = const HugeIcon(
    icon: HugeIcons.strokeRoundedInvoice,
  );
  static final transfer = const HugeIcon(
    icon: HugeIcons.strokeRoundedSquareArrowDataTransferHorizontal,
  );
  static final tags = const HugeIcon(icon: HugeIcons.strokeRoundedTag01);
  static final tagsXs = const HugeIcon(
    icon: HugeIcons.strokeRoundedTag01,
    size: AppSizing.iconXs,
  );
  static Widget transactionIncome(Color color) =>
      HugeIcon(icon: HugeIcons.strokeRoundedChartIncrease, color: color);
  static Widget transactionExpense(Color color) =>
      HugeIcon(icon: HugeIcons.strokeRoundedChartDecrease, color: color);

  // Accounts
  static final accounts = const HugeIcon(icon: HugeIcons.strokeRoundedWallet02);
  static final accountsOutlined = const HugeIcon(
    icon: HugeIcons.strokeRoundedWallet02,
  );
  static final accountsOutlinedXs = const HugeIcon(
    icon: HugeIcons.strokeRoundedWallet02,
    size: AppSizing.iconXs,
  );

  // Categories
  static final categories = const HugeIcon(
    icon: HugeIcons.strokeRoundedFolderLibrary,
  );
  static final categoriesOutlined = const HugeIcon(
    icon: HugeIcons.strokeRoundedFolderLibrary,
  );
  static final categoriesOutlinedXs = const HugeIcon(
    icon: HugeIcons.strokeRoundedFolderLibrary,
    size: AppSizing.iconXs,
  );

  // Settings
  static final settings = const HugeIcon(
    icon: HugeIcons.strokeRoundedSettings01,
  );
  static final settingsOutlined = const HugeIcon(
    icon: HugeIcons.strokeRoundedSettings01,
  );
  static final info = const HugeIcon(
    icon: HugeIcons.strokeRoundedInformationCircle,
  );
  static final licenses = const HugeIcon(
    icon: HugeIcons.strokeRoundedLicenseThirdParty,
  );
  static final database = const HugeIcon(
    icon: HugeIcons.strokeRoundedDatabase01,
  );
  static final memory = const HugeIcon(icon: HugeIcons.strokeRoundedCpuCharge);
  static final calendar = const HugeIcon(
    icon: HugeIcons.strokeRoundedCalendar03,
  );
  static final schedule = const HugeIcon(icon: HugeIcons.strokeRoundedClock01);

  // Forms
  static final description = const HugeIcon(icon: HugeIcons.strokeRoundedText);
  static final descriptionXs = const HugeIcon(
    icon: HugeIcons.strokeRoundedText,
    size: AppSizing.iconXs,
  );

  // Others
  static final arrowDropDown = const HugeIcon(
    icon: HugeIcons.strokeRoundedArrowDown01,
  );
  static final arrowDropDownXs = Icon(Icons.arrow_drop_down);
  static final arrowDropUp = const HugeIcon(
    icon: HugeIcons.strokeRoundedArrowUp01,
  );
  static final arrowRight = const HugeIcon(
    icon: HugeIcons.strokeRoundedArrowRight02,
  );
  static final currency = const HugeIcon(icon: HugeIcons.strokeRoundedDollar01);
  static final currencyXs = const HugeIcon(
    icon: HugeIcons.strokeRoundedDollar01,
    size: AppSizing.iconXs,
  );
  static final check = const HugeIcon(icon: HugeIcons.strokeRoundedTick02);
  static final checkSm = const HugeIcon(
    icon: HugeIcons.strokeRoundedTick02,
    size: AppSizing.iconSm,
  );
  static Widget checkCircle({Color? color, double? size}) => HugeIcon(
    icon: HugeIcons.strokeRoundedCheckmarkCircle03,
    color: color,
    size: size,
  );
  static Widget errorCircle({Color? color, double? size}) =>
      HugeIcon(icon: HugeIcons.strokeRoundedAlert02, color: color, size: size);
  static Widget infoCircle({Color? color, double? size}) => HugeIcon(
    icon: HugeIcons.strokeRoundedInformationCircle,
    color: color,
    size: size,
  );

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
      case 'transfer':
        return l10n.iconTransfer;
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
    'transfer': HugeIcons.strokeRoundedSquareArrowDataTransferHorizontal,
  };
}
