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
import 'package:plata_sync/features/transactions/model/enums/date_filter.dart';
import 'package:plata_sync/features/transactions/model/enums/sort_order.dart';
import 'package:plata_sync/features/transactions/ui/mixins/transaction_actions_mixin.dart';
import 'package:plata_sync/features/transactions/ui/widgets/date_filter_selector.dart';
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

class _MobileTransactionsScreenState extends State<_MobileTransactionsScreen>
    with TransactionActionsMixin {
  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((TransactionsManager x) => x.isLoading);
    final transactions = watchValue((TransactionsManager x) => x.transactions);
    final sortOrder = watchValue((TransactionsManager x) => x.sortOrder);
    final dateFilter = watchValue(
      (TransactionsManager x) => x.currentDateFilter,
    );
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    checkSampleDataDialog(isLoading, transactions.isEmpty);

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
                actions: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppSizing.inputWidthMd,
                    ),
                    child: DateFilterSelector(
                      value: dateFilter,
                      onChanged: isLoading ? null : manager.setDateFilter,
                      labelBuilder: (filter) =>
                          _getDateFilterLabel(l10n, filter),
                    ),
                  ),
                ],
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

  void _handleCreate(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TransactionEditDialog(
        onSave: (newTransaction) => handleSaveCreate(context, newTransaction),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (_) => TransactionDetailsDialog(
        transaction: transaction,
        onEdit: () => _handleEdit(context, transaction),
        onDelete: () => showDeleteConfirmation(context, transaction),
      ),
    );
  }

  void _handleEdit(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (_) => TransactionEditDialog(
        transaction: transaction,
        onSave: (updatedTransaction) =>
            handleSaveEdit(context, updatedTransaction),
      ),
    );
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

Widget _buildBottomBar(
  BuildContext context,
  TransactionSortOrder sortOrder,
  ViewMode viewMode,
  TransactionsManager manager,
  AppL10n l10n,
  bool isLoading, {
  bool showViewToggle = false,
}) {
  return Row(
    children: [
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppSizing.inputWidthMd),
        child: SortSelector<TransactionSortOrder>(
          value: sortOrder,
          onChanged: isLoading ? null : manager.setSortOrder,
          labelBuilder: (order) => _getSortLabel(l10n, order),
          sortIconBuilder: (order) => order.isDescending
              ? AppIcons.sortDescending
              : AppIcons.sortAscending,
          options: TransactionSortOrder.values,
        ),
      ),
      Spacer(),
      if (showViewToggle) ...[
        AppSpacing.gapHorizontalSm,
        ViewToggle(
          value: viewMode,
          onChanged: isLoading ? null : manager.setViewMode,
        ),
      ],
    ],
  );
}

String _getDateFilterLabel(AppL10n l10n, DateFilter filter) {
  switch (filter) {
    case DateFilter.today:
      return 'Today';
    case DateFilter.week:
      return 'This Week';
    case DateFilter.month:
      return 'This Month';
    case DateFilter.all:
      return 'All Time';
  }
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

// Tablet implementation - uses master-detail layout
class _TabletTransactionsScreen extends WatchingStatefulWidget {
  const _TabletTransactionsScreen();

  @override
  State<_TabletTransactionsScreen> createState() =>
      _TabletTransactionsScreenState();
}

class _TabletTransactionsScreenState extends State<_TabletTransactionsScreen>
    with TransactionActionsMixin {
  Transaction? selectedTransaction;
  bool isEditing = false;
  bool _canSave = false;
  final _editFormKey = GlobalKey<TransactionEditFormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((TransactionsManager x) => x.isLoading);
    final transactions = watchValue((TransactionsManager x) => x.transactions);
    final sortOrder = watchValue((TransactionsManager x) => x.sortOrder);
    final dateFilter = watchValue(
      (TransactionsManager x) => x.currentDateFilter,
    );
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    checkSampleDataDialog(isLoading, transactions.isEmpty);

    final manager = getService<TransactionsManager>();

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Master pane (list)
            Expanded(
              flex: 2,
              child: NestedScrollView(
                headerSliverBuilder: (_, _) {
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
                        showViewToggle: true,
                      ),
                      actions: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: AppSizing.inputWidthMd,
                          ),
                          child: DateFilterSelector(
                            value: dateFilter,
                            onChanged: isLoading ? null : manager.setDateFilter,
                            labelBuilder: (filter) =>
                                _getDateFilterLabel(l10n, filter),
                          ),
                        ),
                      ],
                    ),
                  ];
                },
                body: _buildMasterContent(
                  context,
                  isLoading,
                  transactions,
                  viewMode,
                ),
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            selectedTransaction = null;
                            isEditing = true;
                          });
                        }
                      });
                    },
              icon: AppIcons.add,
              label: Text(l10n.transactionsAddButton),
            ),
    );
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
                onPressed: () => showDeleteConfirmation(
                  context,
                  transaction,
                  onSuccess: () {
                    setState(() {
                      if (selectedTransaction?.id == transaction.id) {
                        selectedTransaction = null;
                        isEditing = false;
                      }
                    });
                  },
                ),
                icon: AppIcons.delete,
                tooltip: l10n.delete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        isEditing = true;
                      });
                    }
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
                      await handleSaveCreate(
                        context,
                        updatedTransaction,
                        onSuccess: () {
                          setState(() {
                            selectedTransaction = updatedTransaction;
                            isEditing = false;
                          });
                        },
                      );
                    } else {
                      await handleSaveEdit(
                        context,
                        updatedTransaction,
                        onSuccess: () {
                          setState(() {
                            selectedTransaction = updatedTransaction;
                            isEditing = false;
                          });
                        },
                      );
                    }
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
}
