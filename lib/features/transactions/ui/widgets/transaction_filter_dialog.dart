import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

import 'account_selector.dart';
import 'category_selector.dart';
import 'tag_selector.dart';

class TransactionFilterDialog extends WatchingStatefulWidget {
  final String? initialAccountId;
  final String? initialCategoryId;
  final List<String>? initialTagIds;
  final void Function(
    String? accountId,
    String? categoryId,
    List<String>? tagIds,
  )
  onApply;

  const TransactionFilterDialog({
    super.key,
    this.initialAccountId,
    this.initialCategoryId,
    this.initialTagIds,
    required this.onApply,
  });

  @override
  State<TransactionFilterDialog> createState() =>
      _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {
  String? _selectedAccountId;
  String? _selectedCategoryId;
  List<String> _selectedTagIds = [];

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.initialAccountId;
    _selectedCategoryId = widget.initialCategoryId;
    _selectedTagIds = widget.initialTagIds ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AppDialog(
      title: l10n.filterTransactions,
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
          TagSelector(
            tagIds: _selectedTagIds,
            onChanged: (tagIds) {
              setState(() {
                _selectedTagIds = tagIds;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onApply(null, null, null);
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
              _selectedAccountId,
              _selectedCategoryId,
              _selectedTagIds.isEmpty ? null : _selectedTagIds,
            );
            Navigator.of(context).pop();
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
