import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_details_view.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class TransactionDetailsDialog extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionDetailsDialog({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    String typeLabel;
    if (transaction.isTransfer) {
      typeLabel = l10n.transactionTypeTransfer;
    } else if (transaction.isExpense) {
      typeLabel = l10n.transactionTypeExpense;
    } else {
      typeLabel = l10n.transactionTypeIncome;
    }

    return AlertDialog(
      insetPadding: AppSpacing.paddingMd,
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(typeLabel, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: TransactionDetailsView(transaction: transaction),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          icon: AppIcons.delete,
          label: Text(l10n.delete),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit();
          },
          icon: AppIcons.edit,
          label: Text(l10n.edit),
        ),
      ],
    );
  }
}
