import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_edit_form.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class TransactionEditDialog extends StatelessWidget {
  final Transaction? transaction;
  final void Function(Transaction updatedTransaction) onSave;

  const TransactionEditDialog({
    this.transaction,
    required this.onSave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AlertDialog(
      title: Text(
        transaction == null
            ? l10n.transactionCreateTitle
            : l10n.transactionEditTitle,
      ),
      content: SizedBox(
        width: AppSizing.dialogMaxWidth,
        child: SingleChildScrollView(
          child: TransactionEditForm(
            transaction: transaction,
            onCancel: () => Navigator.of(context).pop(),
            onSave: (updatedTransaction) {
              Navigator.of(context).pop();
              onSave(updatedTransaction);
            },
          ),
        ),
      ),
    );
  }
}
