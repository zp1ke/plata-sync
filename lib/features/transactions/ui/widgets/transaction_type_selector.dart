import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

enum TransactionType { expense, income, transfer }

/// A widget that allows selecting a transaction type (expense, income, transfer)
class TransactionTypeSelector extends StatelessWidget {
  final TransactionType type;
  final ValueChanged<TransactionType> onChanged;

  const TransactionTypeSelector({
    required this.type,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return SegmentedButton<TransactionType>(
      showSelectedIcon: false,
      segments: [
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
      selected: {type},
      onSelectionChanged: (Set<TransactionType> newSelection) {
        onChanged(newSelection.first);
      },
    );
  }
}
