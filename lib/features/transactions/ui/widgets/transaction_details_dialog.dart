import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_details_view.dart';
import '../../../../l10n/app_localizations.dart';

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

    return AppDialog(
      title: typeLabel,
      content: TransactionDetailsView(transaction: transaction),
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
