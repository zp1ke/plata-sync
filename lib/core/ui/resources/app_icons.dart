import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';

/// A centralized collection of application icons.
/// HugeIcons are used: https://hugeicons.com/icons?style=Stroke&type=Rounded
class AppIcons {
  // Private constructor to prevent instantiation
  const AppIcons._();

  // Actions
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

  // Others
  static final arrowDropDown = HugeIcon(
    icon: HugeIcons.strokeRoundedArrowDown01,
  );
  static final arrowDropUp = HugeIcon(icon: HugeIcons.strokeRoundedArrowUp01);

  // Map for dynamic icon retrieval by name
  static const Map<String, dynamic> iconDataMap = {
    'shopping_cart': HugeIcons.strokeRoundedShoppingCart01,
    'bolt': HugeIcons.strokeRoundedFlashOff,
    'movie': HugeIcons.strokeRoundedVideo01,
  };

  static Widget getIcon(String name, {Color? color, double? size}) {
    final iconData = iconDataMap[name] ?? HugeIcons.strokeRoundedHelpCircle;
    return HugeIcon(icon: iconData, color: color, size: size);
  }
}
