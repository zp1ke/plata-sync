import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/ui/resources/app_colors.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/object_icon.dart';
import '../../../../core/utils/datetime.dart';
import '../../../../core/utils/numbers.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../categories/application/categories_manager.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../tags/application/tags_manager.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/transaction.dart';
import '../../../../l10n/app_localizations.dart';

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
  late final TagsManager _tagsManager;
  Account? _account;
  Category? _category;
  Account? _targetAccount;
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    _accountsManager = getService<AccountsManager>();
    _categoriesManager = getService<CategoriesManager>();
    _tagsManager = getService<TagsManager>();
    _loadData();
  }

  @override
  void didUpdateWidget(TransactionDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if the transaction changed
    if (oldWidget.transaction.id != widget.transaction.id) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    _account = await _accountsManager.getAccountById(
      widget.transaction.accountId,
    );
    if (widget.transaction.categoryId != null) {
      _category = await _categoriesManager.getCategoryById(
        widget.transaction.categoryId!,
      );
    }
    if (widget.transaction.targetAccountId != null) {
      _targetAccount = await _accountsManager.getAccountById(
        widget.transaction.targetAccountId!,
      );
    }
    _tags = await _tagsManager.getTagsByIds(widget.transaction.tagIds);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final transaction = widget.transaction;

    final typeColor = switch (transaction) {
      _ when transaction.isTransfer => Theme.of(context).colorScheme.transfer,
      _ when transaction.isExpense => Theme.of(context).colorScheme.expense,
      _ => Theme.of(context).colorScheme.income,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        // Amount and type
        Text(
          transaction.amount.asCurrency(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: typeColor,
          ),
        ),
        // Balance before & after
        _buildSection(
          context,
          label: l10n.transactionBalanceMovementLabel,
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Text(
                transaction.accountBalanceBefore.asCurrency(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              AppIcons.arrowRight,
              Text(
                transaction.accountBalanceAfter.asCurrency(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            // Category (if not transfer)
            if (_category != null)
              _buildIconSection(
                context,
                label: l10n.transactionCategoryLabel,
                iconData: _category!.iconData,
                name: _category!.name,
              ),
            // Account
            _buildIconSection(
              context,
              label: l10n.transactionAccountLabel,
              iconData: _account?.iconData,
              name: _account?.name ?? l10n.accountsEmptyState,
            ),
            // Target account (if transfer)
            if (_targetAccount != null)
              _buildIconSection(
                context,
                label: l10n.transactionTargetAccountLabel,
                iconData: _targetAccount!.iconData,
                name: _targetAccount!.name,
              ),
          ],
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
        // Tags
        if (_tags.isNotEmpty)
          _buildSection(
            context,
            label: l10n.transactionTagsLabel,
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag.name),
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  visualDensity: VisualDensity.compact,
                  padding: AppSpacing.paddingHorizontalXs,
                );
              }).toList(),
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
    if (label == null) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
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

  Widget _buildIconSection(
    BuildContext context, {
    required String label,
    ObjectIconData? iconData,
    required String name,
  }) {
    return _buildSection(
      context,
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          if (iconData != null)
            ObjectIcon(
              iconData: iconData,
              size: widget.showLargeIcon ? AppSizing.iconLg : AppSizing.iconMd,
            ),
          Text(name, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
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
          width: AppSizing.boxWidthSm,
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
