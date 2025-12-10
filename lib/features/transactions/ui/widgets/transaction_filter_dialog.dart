import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

import 'account_selector.dart';
import 'category_selector.dart';

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

    return AlertDialog(
      title: Text(l10n.filterTransactions),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          AccountSelector(
            accountId: _selectedAccountId,
            label: l10n.transactionAccountLabel,
            onChanged: (accountId) {
              setState(() {
                _selectedAccountId = accountId;
              });
            },
          ),
          CategorySelector(
            categoryId: _selectedCategoryId,
            onChanged: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId;
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
