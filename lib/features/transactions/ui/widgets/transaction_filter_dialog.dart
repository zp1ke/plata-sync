import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/ui/widgets/select_field.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class TransactionFilterDialog extends WatchingStatefulWidget {
  final String? initialAccountId;
  final String? initialCategoryId;
  final void Function(String? accountId, String? categoryId) onApply;

  const TransactionFilterDialog({
    super.key,
    this.initialAccountId,
    this.initialCategoryId,
    required this.onApply,
  });

  @override
  State<TransactionFilterDialog> createState() =>
      _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {
  String? _selectedAccountId;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.initialAccountId;
    _selectedCategoryId = widget.initialCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final accounts = watchValue((AccountsManager x) => x.accounts);
    final categories = watchValue((CategoriesManager x) => x.categories);

    return AlertDialog(
      title: Text(l10n.filterTransactions),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectField<Account>(
            value: accounts
                .where((a) => a.id == _selectedAccountId)
                .firstOrNull,
            options: accounts,
            label: l10n.transactionAccountLabel,
            hint: l10n.selectAccount,
            searchHint: l10n.searchAccounts,
            itemBuilder: (account) => Row(
              children: [
                ObjectIcon(iconData: account.iconData),
                AppSpacing.gapHorizontalSm,
                Expanded(child: Text(account.name)),
              ],
            ),
            searchFilter: (account, query) =>
                account.name.toLowerCase().contains(query.toLowerCase()),
            onChanged: (account) {
              setState(() {
                _selectedAccountId = account.id;
              });
            },
          ),
          AppSpacing.gapVerticalMd,
          SelectField<Category>(
            value: categories
                .where((c) => c.id == _selectedCategoryId)
                .firstOrNull,
            options: categories,
            label: l10n.transactionCategoryLabel,
            hint: l10n.selectCategory,
            searchHint: l10n.searchCategories,
            itemBuilder: (category) => Row(
              children: [
                ObjectIcon(iconData: category.iconData),
                AppSpacing.gapHorizontalSm,
                Expanded(child: Text(category.name)),
              ],
            ),
            searchFilter: (category, query) =>
                category.name.toLowerCase().contains(query.toLowerCase()),
            onChanged: (category) {
              setState(() {
                _selectedCategoryId = category.id;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onApply(null, null);
            Navigator.of(context).pop();
          },
          child: Text(l10n.clear),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onApply(_selectedAccountId, _selectedCategoryId);
            Navigator.of(context).pop();
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
