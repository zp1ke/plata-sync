import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/app_top_bar.dart';
import 'package:plata_sync/core/ui/widgets/responsive_layout.dart';
import 'package:plata_sync/core/ui/widgets/sort_selector.dart';
import 'package:plata_sync/core/ui/widgets/view_toggle.dart';
import 'package:plata_sync/features/transactions/application/transactions_manager.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_details_dialog.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_details_view.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_edit_dialog.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_edit_form.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_grid_view.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_list_view.dart';
import 'package:plata_sync/l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class TransactionsScreen extends WatchingWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => const _MobileTransactionsScreen(),
      tabletOrLarger: (context) => const _TabletTransactionsScreen(),
    );
  }
}

// Mobile implementation - uses dialogs
class _MobileTransactionsScreen extends WatchingStatefulWidget {
  const _MobileTransactionsScreen();

  @override
  State<_MobileTransactionsScreen> createState() =>
      _MobileTransactionsScreenState();
}

class _MobileTransactionsScreenState extends State<_MobileTransactionsScreen> {
  bool _hasShownSampleDialog = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((TransactionsManager x) => x.isLoading);
    final transactions = watchValue((TransactionsManager x) => x.transactions);
    final sortOrder = watchValue((TransactionsManager x) => x.sortOrder);
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    if (!_hasShownSampleDialog && !isLoading && transactions.isEmpty) {
      _hasShownSampleDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showSampleDataDialog(context);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, _) {
            final manager = getService<TransactionsManager>();
            return [
              AppTopBar(
                title: l10n.transactionsScreenTitle,
                isLoading: isLoading,
                onRefresh: () => manager.loadTransactions(),
                bottom: _buildBottomBar(
                  context,
                  sortOrder,
                  viewMode,
                  manager,
                  l10n,
                  isLoading,
                ),
              ),
            ];
          },
          body: _buildContent(context, isLoading, transactions, viewMode),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : () => _handleCreate(context),
        child: AppIcons.add,
      ),
    );
  }

  PreferredSizeWidget _buildBottomBar(
    BuildContext context,
    TransactionSortOrder sortOrder,
    ViewMode viewMode,
    TransactionsManager manager,
    AppL10n l10n,
    bool isLoading,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Column(
        children: [
          const Divider(),
          Padding(
            padding: AppSpacing.paddingMd,
            child: Row(
              children: [
                Expanded(
                  child: SortSelector<TransactionSortOrder>(
                    value: sortOrder,
                    onChanged: isLoading ? null : manager.setSortOrder,
                    labelBuilder: (order) => _getSortLabel(l10n, order),
                    sortIconBuilder: (order) => order.name.contains('Desc')
                        ? AppIcons.sortDescending
                        : AppIcons.sortAscending,
                    options: TransactionSortOrder.values,
                  ),
                ),
                AppSpacing.gapHorizontalSm,
                ViewToggle(
                  value: viewMode,
                  onChanged: isLoading ? null : manager.setViewMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(AppL10n l10n, TransactionSortOrder order) {
    switch (order) {
      case TransactionSortOrder.dateAsc:
        return l10n.transactionsSortDateAsc;
      case TransactionSortOrder.dateDesc:
        return l10n.transactionsSortDateDesc;
      case TransactionSortOrder.amountAsc:
        return l10n.transactionsSortAmountAsc;
      case TransactionSortOrder.amountDesc:
        return l10n.transactionsSortAmountDesc;
    }
  }

  void _showSampleDataDialog(BuildContext context) {
    final l10n = AppL10n.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: AppSpacing.paddingMd,
        title: Text(l10n.transactionsEmptyState),
        content: Text(l10n.transactionsAddSampleDataPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _handleCreateSampleData(context);
            },
            child: Text(l10n.addSampleData),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreateSampleData(BuildContext context) async {
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

  void _handleCreate(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TransactionEditDialog(
        onSave: (newTransaction) => _handleSaveCreate(context, newTransaction),
      ),
    );
  }

  Future<void> _handleSaveCreate(
    BuildContext context,
    Transaction transaction,
  ) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.addTransaction(transaction);
      if (context.mounted) {
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

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (_) => TransactionDetailsDialog(
        transaction: transaction,
        onEdit: () => _handleEdit(context, transaction),
        onDelete: () => _handleDelete(context, transaction),
      ),
    );
  }

  void _handleEdit(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (_) => TransactionEditDialog(
        transaction: transaction,
        onSave: (updatedTransaction) =>
            _handleSaveEdit(context, updatedTransaction),
      ),
    );
  }

  Future<void> _handleSaveEdit(
    BuildContext context,
    Transaction transaction,
  ) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.updateTransaction(transaction);
      if (context.mounted) {
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

  void _handleDelete(BuildContext context, Transaction transaction) {
    final l10n = AppL10n.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: AppSpacing.paddingMd,
        title: Text(l10n.confirmDelete),
        content: Text(l10n.transactionsDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _performDelete(context, transaction);
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

  Future<void> _performDelete(
    BuildContext context,
    Transaction transaction,
  ) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.deleteTransaction(transaction.id);
      if (context.mounted) {
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

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Transaction> transactions,
    ViewMode viewMode,
  ) {
    final l10n = AppL10n.of(context);
    if (isLoading && transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (transactions.isEmpty) {
      return Center(child: Text(l10n.transactionsEmptyState));
    }

    return viewMode == ViewMode.list
        ? TransactionListView(
            transactions: transactions,
            onTap: isLoading
                ? null
                : (transaction) =>
                      _showTransactionDetails(context, transaction),
          )
        : TransactionGridView(
            transactions: transactions,
            onTap: isLoading
                ? null
                : (transaction) =>
                      _showTransactionDetails(context, transaction),
          );
  }
}

// Tablet implementation - uses master-detail layout
class _TabletTransactionsScreen extends WatchingStatefulWidget {
  const _TabletTransactionsScreen();

  @override
  State<_TabletTransactionsScreen> createState() =>
      _TabletTransactionsScreenState();
}

class _TabletTransactionsScreenState extends State<_TabletTransactionsScreen> {
  Transaction? selectedTransaction;
  bool isEditing = false;
  bool _hasShownSampleDialog = false;
  bool _canSave = false;
  final _editFormKey = GlobalKey<TransactionEditFormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((TransactionsManager x) => x.isLoading);
    final transactions = watchValue((TransactionsManager x) => x.transactions);
    final sortOrder = watchValue((TransactionsManager x) => x.sortOrder);
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    if (!_hasShownSampleDialog && !isLoading && transactions.isEmpty) {
      _hasShownSampleDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showSampleDataDialog(context);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Master pane (list)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildMasterHeader(
                    context,
                    sortOrder,
                    viewMode,
                    isLoading,
                    l10n,
                  ),
                  const Divider(),
                  Expanded(
                    child: _buildMasterContent(
                      context,
                      isLoading,
                      transactions,
                      viewMode,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            // Detail pane
            Expanded(
              flex: 3,
              child: _buildDetailPane(context, isLoading, l10n),
            ),
          ],
        ),
      ),
      floatingActionButton: isEditing
          ? null
          : FloatingActionButton.extended(
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        selectedTransaction = null;
                        isEditing = true;
                      });
                    },
              icon: AppIcons.add,
              label: Text(l10n.transactionsAddButton),
            ),
    );
  }

  Widget _buildMasterHeader(
    BuildContext context,
    TransactionSortOrder sortOrder,
    ViewMode viewMode,
    bool isLoading,
    AppL10n l10n,
  ) {
    final manager = getService<TransactionsManager>();
    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.transactionsScreenTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              IconButton(
                icon: isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      )
                    : AppIcons.refresh,
                onPressed: isLoading ? null : () => manager.loadTransactions(),
                tooltip: l10n.refresh,
              ),
            ],
          ),
          AppSpacing.gapVerticalSm,
          Row(
            children: [
              Expanded(
                child: SortSelector<TransactionSortOrder>(
                  value: sortOrder,
                  onChanged: isLoading ? null : manager.setSortOrder,
                  labelBuilder: (order) => _getSortLabel(l10n, order),
                  sortIconBuilder: (order) => order.name.contains('Desc')
                      ? AppIcons.sortDescending
                      : AppIcons.sortAscending,
                  options: TransactionSortOrder.values,
                ),
              ),
              AppSpacing.gapHorizontalSm,
              ViewToggle(
                value: viewMode,
                onChanged: isLoading ? null : manager.setViewMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getSortLabel(AppL10n l10n, TransactionSortOrder order) {
    switch (order) {
      case TransactionSortOrder.dateAsc:
        return l10n.transactionsSortDateAsc;
      case TransactionSortOrder.dateDesc:
        return l10n.transactionsSortDateDesc;
      case TransactionSortOrder.amountAsc:
        return l10n.transactionsSortAmountAsc;
      case TransactionSortOrder.amountDesc:
        return l10n.transactionsSortAmountDesc;
    }
  }

  Widget _buildMasterContent(
    BuildContext context,
    bool isLoading,
    List<Transaction> transactions,
    ViewMode viewMode,
  ) {
    final l10n = AppL10n.of(context);
    if (isLoading && transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (transactions.isEmpty) {
      return Center(child: Text(l10n.transactionsEmptyState));
    }

    return viewMode == ViewMode.list
        ? TransactionListView(
            transactions: transactions,
            selectedTransactionId: selectedTransaction?.id,
            onTap: isLoading
                ? null
                : (transaction) {
                    setState(() {
                      selectedTransaction = transaction;
                      isEditing = false;
                    });
                  },
          )
        : TransactionGridView(
            transactions: transactions,
            selectedTransactionId: selectedTransaction?.id,
            onTap: isLoading
                ? null
                : (transaction) {
                    setState(() {
                      selectedTransaction = transaction;
                      isEditing = false;
                    });
                  },
          );
  }

  Widget _buildDetailPane(BuildContext context, bool isLoading, AppL10n l10n) {
    if (isEditing) {
      return _buildEditView();
    }

    if (selectedTransaction == null) {
      return Center(
        child: Text(
          l10n.transactionsSelectPrompt,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return _buildDetailsView();
  }

  Widget _buildDetailsView() {
    final transaction = selectedTransaction!;
    final l10n = AppL10n.of(context);

    return Column(
      children: [
        // Header with actions
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getTransactionTypeLabel(context, transaction),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => _handleDelete(context, transaction),
                icon: AppIcons.delete,
                tooltip: l10n.delete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                icon: AppIcons.edit,
                tooltip: l10n.edit,
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TransactionDetailsView(
              transaction: transaction,
              showLargeIcon: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditView() {
    final l10n = AppL10n.of(context);

    void triggerSave() {
      _editFormKey.currentState?.handleSave();
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedTransaction == null
                      ? l10n.transactionCreateTitle
                      : l10n.transactionEditTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        isEditing = false;
                      });
                    }
                  });
                },
                child: Text(l10n.cancel),
              ),
              AppSpacing.gapHorizontalSm,
              FilledButton(
                onPressed: _canSave ? triggerSave : null,
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
        // Form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizing.dialogMaxWidth,
                ),
                child: TransactionEditForm(
                  key: _editFormKey,
                  transaction: selectedTransaction,
                  showActions: false,
                  onFormValidChanged: (isValid) {
                    setState(() {
                      _canSave = isValid;
                    });
                  },
                  onSave: (updatedTransaction) async {
                    if (selectedTransaction == null) {
                      await _handleSaveCreate(context, updatedTransaction);
                    } else {
                      await _handleSaveEdit(context, updatedTransaction);
                    }
                    setState(() {
                      selectedTransaction = updatedTransaction;
                      isEditing = false;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getTransactionTypeLabel(
    BuildContext context,
    Transaction transaction,
  ) {
    final l10n = AppL10n.of(context);
    if (transaction.isTransfer) {
      return l10n.transactionTypeTransfer;
    } else if (transaction.isExpense) {
      return l10n.transactionTypeExpense;
    } else {
      return l10n.transactionTypeIncome;
    }
  }

  void _showSampleDataDialog(BuildContext context) {
    final l10n = AppL10n.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: AppSpacing.paddingMd,
        title: Text(l10n.transactionsEmptyState),
        content: Text(l10n.transactionsAddSampleDataPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _handleCreateSampleData(context);
            },
            child: Text(l10n.addSampleData),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreateSampleData(BuildContext context) async {
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

  Future<void> _handleSaveCreate(
    BuildContext context,
    Transaction transaction,
  ) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.addTransaction(transaction);
      if (context.mounted) {
        setState(() {
          selectedTransaction = transaction;
          isEditing = false;
        });
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

  Future<void> _handleSaveEdit(
    BuildContext context,
    Transaction transaction,
  ) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.updateTransaction(transaction);
      if (context.mounted) {
        setState(() {
          selectedTransaction = transaction;
          isEditing = false;
        });
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

  void _handleDelete(BuildContext context, Transaction transaction) {
    final l10n = AppL10n.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: AppSpacing.paddingMd,
        title: Text(l10n.confirmDelete),
        content: Text(l10n.transactionsDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _performDelete(context, transaction);
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

  Future<void> _performDelete(
    BuildContext context,
    Transaction transaction,
  ) async {
    final manager = getService<TransactionsManager>();
    final l10n = AppL10n.of(context);
    try {
      await manager.deleteTransaction(transaction.id);
      if (context.mounted) {
        setState(() {
          if (selectedTransaction?.id == transaction.id) {
            selectedTransaction = null;
            isEditing = false;
          }
        });
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
