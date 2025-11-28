import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/resources/app_theme.dart';
import 'package:plata_sync/core/utils/datetime.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A reusable widget that displays transaction details.
class TransactionDetailsView extends StatefulWidget {
  final Transaction transaction;
  final bool showLargeIcon;

  const TransactionDetailsView({
    required this.transaction,
    this.showLargeIcon = false,
    super.key,
  });

  @override
  State<TransactionDetailsView> createState() => _TransactionDetailsViewState();
}

class _TransactionDetailsViewState extends State<TransactionDetailsView> {
  late final AccountsManager _accountsManager;
  late final CategoriesManager _categoriesManager;
  Account? _account;
  Category? _category;
  Account? _targetAccount;

  @override
  void initState() {
    super.initState();
    _accountsManager = getService<AccountsManager>();
    _categoriesManager = getService<CategoriesManager>();
    _loadData();
  }

  Future<void> _loadData() async {
    await _accountsManager.loadAccounts();
    await _categoriesManager.loadCategories();
    if (mounted) {
      setState(() {
        _account = _accountsManager.accounts.value.cast<Account?>().firstWhere(
          (a) => a?.id == widget.transaction.accountId,
          orElse: () => null,
        );
        if (widget.transaction.categoryId != null) {
          _category = _categoriesManager.categories.value
              .cast<Category?>()
              .firstWhere(
                (c) => c?.id == widget.transaction.categoryId,
                orElse: () => null,
              );
        }
        if (widget.transaction.targetAccountId != null) {
          _targetAccount = _accountsManager.accounts.value
              .cast<Account?>()
              .firstWhere(
                (a) => a?.id == widget.transaction.targetAccountId,
                orElse: () => null,
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final transaction = widget.transaction;

    String typeLabel;
    Color typeColor;
    if (transaction.isTransfer) {
      typeLabel = l10n.transactionTypeTransfer;
      typeColor = Theme.of(context).colorScheme.transfer;
    } else if (transaction.isExpense) {
      typeLabel = l10n.transactionTypeExpense;
      typeColor = Theme.of(context).colorScheme.expense;
    } else {
      typeLabel = l10n.transactionTypeIncome;
      typeColor = Theme.of(context).colorScheme.income;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        // Amount and type
        _buildSection(
          context,
          label: l10n.transactionAmountLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(
                NumberFormatters.formatCurrency(transaction.amount),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
              Text(
                typeLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Account
        _buildSection(
          context,
          label: l10n.accountsScreenTitle,
          child: Text(
            _account?.name ?? l10n.accountsEmptyState,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        // Category (if not transfer)
        if (_category != null)
          _buildSection(
            context,
            label: l10n.categoriesScreenTitle,
            child: Text(
              _category!.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        // Target account (if transfer)
        if (_targetAccount != null)
          _buildSection(
            context,
            label: l10n.transactionTargetAccountLabel,
            child: Text(
              _targetAccount!.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        // Notes
        if (transaction.notes != null && transaction.notes!.isNotEmpty)
          _buildSection(
            context,
            label: l10n.transactionNotesLabel,
            child: Text(
              transaction.notes!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        // Metadata section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            _buildInfoRow(
              context,
              label: l10n.transactionIdLabel,
              value: transaction.id,
            ),
            _buildInfoRow(
              context,
              label: l10n.transactionDateLabel,
              value: transaction.createdAt.formatWithTime(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    String? label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        if (label != null)
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        child,
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
