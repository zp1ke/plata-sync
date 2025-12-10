import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_edit_form.dart';
import '../../../../l10n/app_localizations.dart';

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

    return AppDialog(
      title: transaction == null
          ? l10n.transactionCreateTitle
          : l10n.transactionEditTitle,
      contentHeight: 580,
      content: TransactionEditForm(
        transaction: transaction,
        showActions: true,
        onCancel: () => Navigator.of(context).pop(),
        onSave: (updatedTransaction) {
          Navigator.of(context).pop();
          onSave(updatedTransaction);
        },
      ),
    );
  }
}
