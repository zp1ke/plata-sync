import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/enums/view_mode.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/app_top_bar.dart';
import '../../../../core/ui/widgets/responsive_layout.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../categories/application/categories_manager.dart';
import '../../application/transactions_manager.dart';
import '../../domain/entities/transaction.dart';
import '../../model/enums/date_filter.dart';
import '../mixins/transaction_actions_mixin.dart';
import '../utils/transaction_ui_utils.dart';
import '../widgets/transaction_details_view.dart';
import '../widgets/transaction_edit_form.dart';
import '../widgets/transaction_grid_view.dart';
import '../widgets/transaction_list_view.dart';
import '../widgets/transactions_bottom_bar.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class TabletTransactionsScreen extends WatchingStatefulWidget {
  const TabletTransactionsScreen({super.key});

  @override
  State<TabletTransactionsScreen> createState() =>
      _TabletTransactionsScreenState();
}

class _TabletTransactionsScreenState extends State<TabletTransactionsScreen>
    with TransactionActionsMixin {
  Transaction? selectedTransaction;
  bool isEditing = false;
  bool _canSave = false;
  final _editFormKey = GlobalKey<TransactionEditFormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((TransactionsManager x) => x.isLoading);
    final transactions = watchValue((TransactionsManager x) => x.transactions);
    final dateFilter = watchValue(
      (TransactionsManager x) => x.currentDateFilter,
    );
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final hasActiveFilters = watchValue(
      (TransactionsManager x) => x.hasActiveFilters,
    );
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    checkSampleDataDialog(isLoading, transactions.isEmpty);

    return SafeArea(
      child: MasterDetailLayout(
        master: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, _) {
              return [
                AppTopBar(
                  title: l10n.transactionsScreenTitle,
                  isLoading: isLoading,
                  onRefresh: _handleRefresh,
                  bottom: TransactionsBottomBar(showViewToggle: true),
                ),
              ];
            },
            body: _buildMasterContent(
              context,
              isLoading,
              transactions,
              viewMode,
              dateFilter,
              hasActiveFilters,
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
        ),
        detail: _buildDetailPane(),
        detailPlaceholder: Center(
          child: Text(
            l10n.transactionsSelectPrompt,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
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

  Widget _buildMasterContent(
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

  Widget? _buildDetailPane() {
    if (selectedTransaction == null && !isEditing) return null;

    if (isEditing) {
      return _buildEditView();
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
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  getTransactionTypeLabel(l10n, transaction),
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
            padding: AppSpacing.paddingLg,
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
          padding: AppSpacing.paddingMd,
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
            padding: AppSpacing.paddingLg,
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
}
