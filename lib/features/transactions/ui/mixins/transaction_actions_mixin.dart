import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../application/transactions_manager.dart';
import '../../domain/entities/transaction.dart';
import '../../../../l10n/app_localizations.dart';

mixin TransactionActionsMixin<T extends StatefulWidget> on State<T> {
  bool hasShownSampleDialog = false;

  void checkSampleDataDialog(bool isLoading, bool hasTransactions) {
    if (!hasShownSampleDialog && !isLoading && !hasTransactions) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || hasShownSampleDialog) return;

        final manager = getService<TransactionsManager>();
        final hasData = await manager.hasAnyData();

        if (!mounted || hasShownSampleDialog) return;

        setState(() {
          hasShownSampleDialog = true;
        });

        if (context.mounted && !hasData) {
          showSampleDataDialog(context);
        }
      });
    }
  }

  void showSampleDataDialog(BuildContext context) {
    final l10n = AppL10n.of(context);
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: l10n.transactionsEmptyState,
        content: Text(l10n.transactionsAddSampleDataPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await handleCreateSampleData(context);
            },
            child: Text(l10n.addSampleData),
          ),
        ],
      ),
    );
  }

  Future<void> handleCreateSampleData(BuildContext context) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.createSampleData();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.sampleDataCreated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sampleDataCreateFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> handleSaveCreate(
    BuildContext context,
    Transaction transaction, {
    VoidCallback? onSuccess,
  }) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.addTransaction(transaction);
      if (context.mounted) {
        onSuccess?.call();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.transactionCreated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.transactionCreateFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> handleSaveEdit(
    BuildContext context,
    Transaction transaction, {
    VoidCallback? onSuccess,
  }) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.updateTransaction(transaction);
      if (context.mounted) {
        onSuccess?.call();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.transactionUpdated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.transactionUpdateFailed(e.toString()))),
        );
      }
    }
  }

  void showDeleteConfirmation(
    BuildContext context,
    Transaction transaction, {
    VoidCallback? onSuccess,
  }) {
    final l10n = AppL10n.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: l10n.confirmDelete,
        content: Text(l10n.transactionsDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await performDelete(context, transaction, onSuccess: onSuccess);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> performDelete(
    BuildContext context,
    Transaction transaction, {
    VoidCallback? onSuccess,
  }) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.deleteTransaction(transaction.id);
      if (context.mounted) {
        onSuccess?.call();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.transactionDeleted)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.transactionDeleteFailed(e.toString()))),
        );
      }
    }
  }
}
