import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/enums/view_mode.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/widgets/app_top_bar.dart';
import '../../application/transactions_manager.dart';
import '../../domain/entities/transaction.dart';
import '../mixins/transaction_actions_mixin.dart';
import '../utils/transaction_ui_utils.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/transaction_details_dialog.dart';
import '../widgets/transaction_edit_dialog.dart';
import '../widgets/transaction_grid_view.dart';
import '../widgets/transaction_list_view.dart';
import '../widgets/transactions_bottom_bar.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class MobileTransactionsScreen extends WatchingStatefulWidget {
  const MobileTransactionsScreen({super.key});

  @override
  State<MobileTransactionsScreen> createState() =>
      _MobileTransactionsScreenState();
}

class _MobileTransactionsScreenState extends State<MobileTransactionsScreen>
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
                bottom: TransactionsBottomBar(
                  sortOrder: sortOrder,
                  viewMode: viewMode,
                  manager: manager,
                  isLoading: isLoading,
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
                          getDateFilterLabel(l10n, filter),
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
