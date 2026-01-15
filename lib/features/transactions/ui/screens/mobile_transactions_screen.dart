import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/enums/view_mode.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/widgets/app_top_bar.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../categories/application/categories_manager.dart';
import '../../application/transactions_manager.dart';
import '../../domain/entities/transaction.dart';
import '../../model/enums/date_filter.dart';
import '../mixins/transaction_actions_mixin.dart';
import '../utils/transaction_ui_utils.dart';
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
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final dateFilter = watchValue(
      (TransactionsManager x) => x.currentDateFilter,
    );
    final hasActiveFilters = watchValue(
      (TransactionsManager x) => x.hasActiveFilters,
    );
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    checkSampleDataDialog(isLoading, transactions.isEmpty);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, _) {
            return [
              AppTopBar(
                title: l10n.transactionsScreenTitle,
                isLoading: isLoading,
                onRefresh: _handleRefresh,
                bottom: TransactionsBottomBar(),
              ),
            ];
          },
          body: _buildContent(
            context,
            isLoading,
            transactions,
            viewMode,
            dateFilter,
            hasActiveFilters,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : () => _handleCreate(context),
        child: AppIcons.add,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      getService<TransactionsManager>().loadTransactions(),
      getService<CategoriesManager>().loadCategories(),
      getService<AccountsManager>().loadAccounts(),
    ]);
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
    DateFilter dateFilter,
    bool hasActiveFilters,
  ) {
    final emptyContent = getTransactionsEmptyContent(
      context,
      isLoading,
      transactions,
      dateFilter,
      hasActiveFilters,
    );
    if (emptyContent != null) {
      return emptyContent;
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
