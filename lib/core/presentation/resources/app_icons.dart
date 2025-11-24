import 'package:flutter/material.dart';

class AppIcons {
  // Private constructor to prevent instantiation
  const AppIcons._();

  // Actions
  static const IconData clear = Icons.clear;
  static const IconData refresh = Icons.refresh;
  static const IconData search = Icons.search;
  static const IconData searchOff = Icons.search_off;

  // Transactions
  static const IconData transactions = Icons.receipt_long;
  static const IconData transactionsOutlined = Icons.receipt_long_outlined;

  // Accounts
  static const IconData accounts = Icons.account_balance_wallet;
  static const IconData accountsOutlined =
      Icons.account_balance_wallet_outlined;

  // Categories
  static const IconData categories = Icons.category;
  static const IconData categoriesOutlined = Icons.category_outlined;

  // Settings
  static const IconData settings = Icons.settings;
  static const IconData settingsOutlined = Icons.settings_outlined;

  // Map for dynamic icon retrieval
  static const Map<String, IconData> iconMap = {
    // categories
    'shopping_cart': Icons.shopping_cart,
    'bolt': Icons.bolt,
    'movie': Icons.movie,
  };

  static IconData getIcon(String name) {
    return iconMap[name] ?? Icons.help_outline;
  }
}
