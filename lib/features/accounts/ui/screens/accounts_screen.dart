import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/enums/view_mode.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/app_top_bar.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../core/ui/widgets/responsive_layout.dart';
import '../../../../core/ui/widgets/snack_alert.dart';
import '../../../../core/ui/widgets/sort_selector.dart';
import '../../../../core/ui/widgets/view_toggle.dart';
import '../../../../core/utils/numbers.dart';
import '../../../../core/utils/random.dart';
import '../../../transactions/application/transactions_manager.dart';
import '../../application/accounts_manager.dart';
import '../../domain/entities/account.dart';
import '../../model/enums/sort_order.dart';
import '../widgets/account_details_dialog.dart';
import '../widgets/account_details_view.dart';
import '../widgets/account_edit_dialog.dart';
import '../widgets/account_edit_form.dart';
import '../widgets/account_grid_view.dart';
import '../widgets/account_list_view.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class AccountsScreen extends WatchingWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => const _MobileAccountsScreen(),
      tabletOrLarger: (context) => const _TabletAccountsScreen(),
    );
  }
}

// Mobile implementation - uses dialogs
class _MobileAccountsScreen extends WatchingStatefulWidget {
  const _MobileAccountsScreen();

  @override
  State<_MobileAccountsScreen> createState() => _MobileAccountsScreenState();
}

String _title(AppL10n l10n, List<Account> accounts) {
  if (accounts.isEmpty) {
    return l10n.accountsScreenTitle;
  }
  final totalBalance = accounts.fold<int>(
    0,
    (sum, account) => sum + account.balance,
  );
  return '${l10n.accountsScreenTitle} · ${NumberFormatters.formatCompactCurrency(totalBalance)}';
}

class _MobileAccountsScreenState extends State<_MobileAccountsScreen> {
  bool _hasShownSampleDialog = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AccountsManager x) => x.isLoading);
    final hasLoadedOnce = watchValue((AccountsManager x) => x.hasLoadedOnce);
    final accounts = watchValue((AccountsManager x) => x.accounts);
    final currentQuery = watchValue((AccountsManager x) => x.currentQuery);
    final sortOrder = watchValue((AccountsManager x) => x.sortOrder);
    final viewMode = watchValue((AccountsManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    if (!_hasShownSampleDialog &&
        hasLoadedOnce &&
        !isLoading &&
        accounts.isEmpty &&
        currentQuery.isEmpty) {
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
            final manager = getService<AccountsManager>();
            return [
              AppTopBar(
                title: _title(l10n, accounts),
                searchHint: l10n.accountsSearchHint,
                onSearchChanged: (value) => manager.loadAccounts(query: value),
                isLoading: isLoading,
                onRefresh: () => manager.loadAccounts(),
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
          body: _buildContent(
            context,
            isLoading,
            accounts,
            currentQuery,
            viewMode,
          ),
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
      builder: (_) => AccountEditDialog(
        onSave: (newAccount) => _handleSaveCreate(context, newAccount),
      ),
    );
  }

  void _showAccountDetails(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (_) => AccountDetailsDialog(
        account: account,
        onEdit: () => _handleEdit(context, account),
        onDuplicate: () => _handleDuplicate(context, account),
        onDelete: () => _handleDelete(context, account),
        onViewTransactions: () => _handleViewTransactions(context, account),
      ),
    );
  }

  void _handleEdit(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (_) => AccountEditDialog(
        account: account,
        onSave: (updatedAccount) => _handleSaveEdit(context, updatedAccount),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Account> accounts,
    String currentQuery,
    ViewMode viewMode,
  ) {
    final l10n = AppL10n.of(context);
    if (isLoading && accounts.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (accounts.isEmpty) {
      if (currentQuery.isNotEmpty) {
        return Center(child: Text(l10n.accountsNoSearchResults(currentQuery)));
      }
      return Center(child: Text(l10n.accountsEmptyState));
    }

    return viewMode == ViewMode.list
        ? AccountListView(
            accounts: accounts,
            onTap: isLoading
                ? null
                : (account) => _showAccountDetails(context, account),
          )
        : AccountGridView(
            accounts: accounts,
            onTap: isLoading
                ? null
                : (account) => _showAccountDetails(context, account),
          );
  }
}

// Tablet implementation - uses master-detail layout
class _TabletAccountsScreen extends WatchingStatefulWidget {
  const _TabletAccountsScreen();

  @override
  State<_TabletAccountsScreen> createState() => _TabletAccountsScreenState();
}

class _TabletAccountsScreenState extends State<_TabletAccountsScreen> {
  Account? selectedAccount;
  bool isEditing = false;
  final _editFormKey = GlobalKey<AccountEditFormState>();
  bool _canSave = false;
  bool _hasShownSampleDialog = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AccountsManager x) => x.isLoading);
    final hasLoadedOnce = watchValue((AccountsManager x) => x.hasLoadedOnce);
    final accounts = watchValue((AccountsManager x) => x.accounts);
    final currentQuery = watchValue((AccountsManager x) => x.currentQuery);
    final sortOrder = watchValue((AccountsManager x) => x.sortOrder);
    final viewMode = watchValue((AccountsManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    if (!_hasShownSampleDialog &&
        hasLoadedOnce &&
        !isLoading &&
        accounts.isEmpty &&
        currentQuery.isEmpty) {
      _hasShownSampleDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showSampleDataDialog(context);
        }
      });
    }

    return SafeArea(
      child: MasterDetailLayout(
        master: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, _) {
              final manager = getService<AccountsManager>();
              return [
                AppTopBar(
                  title: _title(l10n, accounts),
                  searchHint: l10n.accountsSearchHint,
                  onSearchChanged: (value) =>
                      manager.loadAccounts(query: value),
                  isLoading: isLoading,
                  onRefresh: () => manager.loadAccounts(),
                  bottom: _buildBottomBar(
                    context,
                    sortOrder,
                    viewMode,
                    manager,
                    l10n,
                    isLoading,
                    showViewToggle: true,
                  ),
                ),
              ];
            },
            body: _buildContent(
              context,
              isLoading,
              accounts,
              currentQuery,
              viewMode,
              selectedAccountId: selectedAccount?.id,
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
                                selectedAccount = null;
                                isEditing = true;
                              });
                            }
                          });
                        },
                  icon: AppIcons.add,
                  label: Text(l10n.accountsAddButton),
                ),
        ),
        detail: _buildDetailPane(),
        detailPlaceholder: Center(
          child: Text(
            l10n.accountsSelectPrompt,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget? _buildDetailPane() {
    if (selectedAccount == null && !isEditing) return null;

    if (isEditing) {
      return _buildEditView();
    }

    return _buildDetailsView();
  }

  Widget _buildDetailsView() {
    final account = selectedAccount!;
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
                  account.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => _handleViewTransactions(context, account),
                icon: AppIcons.transactions,
                tooltip: l10n.accountsViewTransactions,
              ),
              IconButton(
                onPressed: () => _handleDelete(context, account),
                icon: AppIcons.delete,
                tooltip: l10n.delete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              IconButton(
                onPressed: () => _handleDuplicate(context, account),
                icon: AppIcons.copy,
                tooltip: l10n.duplicate,
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
            child: AccountDetailsView(account: account, showLargeIcon: true),
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
                  selectedAccount == null
                      ? l10n.accountsCreateTitle
                      : l10n.accountsEditTitle,
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
              const SizedBox(width: AppSpacing.sm),
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
                child: AccountEditForm(
                  key: _editFormKey,
                  account: selectedAccount,
                  showActions: false,
                  onFormValidChanged: (isValid) {
                    setState(() {
                      _canSave = isValid;
                    });
                  },
                  onSave: (updatedAccount) async {
                    if (selectedAccount == null) {
                      await _handleSaveCreate(context, updatedAccount);
                    } else {
                      await _handleSaveEdit(context, updatedAccount);
                    }
                    setState(() {
                      selectedAccount = updatedAccount;
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

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Account> accounts,
    String currentQuery,
    ViewMode viewMode, {
    String? selectedAccountId,
  }) {
    final l10n = AppL10n.of(context);
    if (isLoading && accounts.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (accounts.isEmpty) {
      if (currentQuery.isNotEmpty) {
        return Center(child: Text(l10n.accountsNoSearchResults(currentQuery)));
      }
      return Center(child: Text(l10n.accountsEmptyState));
    }

    return viewMode == ViewMode.list
        ? AccountListView(
            accounts: accounts,
            selectedAccountId: selectedAccountId,
            onTap: isLoading
                ? null
                : (account) {
                    setState(() {
                      selectedAccount = account;
                      isEditing = false;
                    });
                  },
          )
        : AccountGridView(
            accounts: accounts,
            selectedAccountId: selectedAccountId,
            onTap: isLoading
                ? null
                : (account) {
                    setState(() {
                      selectedAccount = account;
                      isEditing = false;
                    });
                  },
          );
  }
}

// Shared helper methods
void _handleViewTransactions(BuildContext context, Account account) {
  // Set the account filter in TransactionsManager
  final transactionsManager = getService<TransactionsManager>();
  transactionsManager.setAccountFilter([account.id]);

  // Navigate to transactions screen
  context.go(AppRoutes.transactions);
}

Future<void> _showSampleDataDialog(BuildContext context) async {
  final l10n = AppL10n.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: l10n.accountsEmptyState,
      content: Text(l10n.accountsAddSampleDataPrompt),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.no),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.yes),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    final manager = getService<AccountsManager>();
    await manager.createSampleData();
  }
}

Widget _buildBottomBar(
  BuildContext context,
  AccountSortOrder sortOrder,
  ViewMode viewMode,
  AccountsManager manager,
  AppL10n l10n,
  bool isLoading, {
  bool showViewToggle = false,
}) {
  return Row(
    children: [
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppSizing.inputWidthMd),
        child: SortSelector<AccountSortOrder>(
          value: sortOrder,
          onChanged: isLoading ? null : manager.setSortOrder,
          labelBuilder: (order) => _sortLabel(order, l10n),
          sortIconBuilder: (order) => order.isDescending
              ? AppIcons.sortDescending
              : AppIcons.sortAscending,
          options: AccountSortOrder.values,
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

String _sortLabel(AccountSortOrder sortOrder, AppL10n l10n) {
  switch (sortOrder) {
    case AccountSortOrder.nameAsc:
      return l10n.accountsSortNameAsc;
    case AccountSortOrder.nameDesc:
      return l10n.accountsSortNameDesc;
    case AccountSortOrder.lastUsedAsc:
      return l10n.accountsSortLastUsedAsc;
    case AccountSortOrder.lastUsedDesc:
      return l10n.accountsSortLastUsedDesc;
    case AccountSortOrder.balanceAsc:
      return l10n.accountsSortBalanceAsc;
    case AccountSortOrder.balanceDesc:
      return l10n.accountsSortBalanceDesc;
  }
}

Future<void> _handleSaveCreate(BuildContext context, Account newAccount) async {
  final l10n = AppL10n.of(context);
  final manager = getService<AccountsManager>();
  try {
    await manager.addAccount(newAccount);
    if (context.mounted) {
      SnackAlert.success(
        context,
        message: l10n.accountCreated(newAccount.name),
      );
    }
  } catch (e) {
    if (context.mounted) {
      SnackAlert.error(
        context,
        message: l10n.accountCreateFailed(e.toString()),
      );
    }
  }
}

Future<void> _handleSaveEdit(
  BuildContext context,
  Account updatedAccount,
) async {
  final l10n = AppL10n.of(context);
  final manager = getService<AccountsManager>();
  try {
    await manager.updateAccount(updatedAccount);
    if (context.mounted) {
      SnackAlert.success(
        context,
        message: l10n.accountUpdated(updatedAccount.name),
      );
    }
  } catch (e) {
    if (context.mounted) {
      SnackAlert.error(
        context,
        message: l10n.accountUpdateFailed(e.toString()),
      );
    }
  }
}

Future<void> _handleDuplicate(BuildContext context, Account account) async {
  final l10n = AppL10n.of(context);
  final manager = getService<AccountsManager>();
  try {
    final duplicated = account.copyWith(
      id: randomId(),
      createdAt: DateTime.now(),
      name: '${account.name} (${l10n.copy})',
      lastUsed: null,
    );
    await manager.addAccount(duplicated);
    if (context.mounted) {
      SnackAlert.success(
        context,
        message: l10n.accountDuplicated(account.name),
      );
    }
  } catch (e) {
    if (context.mounted) {
      SnackAlert.error(
        context,
        message: l10n.accountDuplicateFailed(account.name, e.toString()),
      );
    }
  }
}

Future<void> _handleDelete(BuildContext context, Account account) async {
  final l10n = AppL10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: l10n.delete,
      content: Text(l10n.accountsDeleteConfirmation(account.name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.no),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final manager = getService<AccountsManager>();
    try {
      await manager.deleteAccount(account.id);
      if (context.mounted) {
        SnackAlert.success(context, message: l10n.accountDeleted(account.name));
      }
    } catch (e) {
      if (context.mounted) {
        SnackAlert.error(
          context,
          message: l10n.accountDeleteFailed(account.name, e.toString()),
        );
      }
    }
  }
}
