import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

import '../../../accounts/application/accounts_manager.dart';
import '../../../categories/application/categories_manager.dart';
import '../../../tags/application/tags_manager.dart';
import 'multi_account_selector.dart';
import 'multi_category_selector.dart';
import 'tag_selector.dart';
import 'transaction_type_selector.dart';

class TransactionFilterDialog extends WatchingStatefulWidget {
  final List<String>? initialAccountIds;
  final List<String>? initialCategoryIds;
  final List<String>? initialTagIds;
  final TransactionType? initialTransactionType;
  final void Function(
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
    TransactionType? transactionType,
  )
  onApply;

  const TransactionFilterDialog({
    super.key,
    this.initialAccountIds,
    this.initialCategoryIds,
    this.initialTagIds,
    this.initialTransactionType,
    required this.onApply,
  });

  @override
  State<TransactionFilterDialog> createState() =>
      _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {
  List<String> _selectedAccountIds = [];
  List<String> _selectedCategoryIds = [];
  List<String> _selectedTagIds = [];
  TransactionType? _selectedTransactionType;

  @override
  void initState() {
    super.initState();
    _selectedAccountIds = widget.initialAccountIds ?? [];
    _selectedCategoryIds = widget.initialCategoryIds ?? [];
    _selectedTagIds = widget.initialTagIds ?? [];
    _selectedTransactionType = widget.initialTransactionType;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final accounts = watchValue((AccountsManager x) => x.accounts);
    final categories = watchValue((CategoriesManager x) => x.categories);
    final tags = watchValue((TagsManager x) => x.tags);

    List<String> normalizeSelection(List<String> selected, int total) {
      if (total > 0 && selected.length == total) {
        return <String>[];
      }
      return selected;
    }

    return AppDialog(
      title: l10n.filterTransactions,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          MultiAccountSelector(
            accountIds: _selectedAccountIds,
            label: l10n.transactionAccountLabel,
            onChanged: (accountIds) {
              setState(() {
                _selectedAccountIds = normalizeSelection(
                  accountIds,
                  accounts.length,
                );
              });
            },
          ),
          MultiCategorySelector(
            categoryIds: _selectedCategoryIds,
            onChanged: (categoryIds) {
              setState(() {
                _selectedCategoryIds = normalizeSelection(
                  categoryIds,
                  categories.length,
                );
              });
            },
          ),
          TagSelector(
            tagIds: _selectedTagIds,
            onChanged: (tagIds) {
              setState(() {
                _selectedTagIds = normalizeSelection(tagIds, tags.length);
              });
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(
                l10n.transactionTypeFilter,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SegmentedButton<TransactionType?>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: null,
                    label: Text(l10n.transactionTypeAll),
                  ),
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text(l10n.transactionTypeExpense),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text(l10n.transactionTypeIncome),
                  ),
                  ButtonSegment(
                    value: TransactionType.transfer,
                    label: Text(l10n.transactionTypeTransfer),
                  ),
                ],
                selected: {_selectedTransactionType},
                onSelectionChanged: (Set<TransactionType?> newSelection) {
                  setState(() {
                    _selectedTransactionType = newSelection.first;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onApply(null, null, null, null);
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
            widget.onApply(
              _selectedAccountIds.isEmpty ? null : _selectedAccountIds,
              _selectedCategoryIds.isEmpty ? null : _selectedCategoryIds,
              _selectedTagIds.isEmpty ? null : _selectedTagIds,
              _selectedTransactionType,
            );
            Navigator.of(context).pop();
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
