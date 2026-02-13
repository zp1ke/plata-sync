import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/widgets/snack_alert.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/currency_input_field.dart';
import '../../../../core/ui/widgets/date_picker_field.dart';
import '../../../../core/ui/widgets/date_time_picker_field.dart';
import '../../../../core/ui/widgets/description_input.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../tags/application/tags_manager.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/transaction.dart';
import 'account_selector.dart';
import 'category_selector.dart';
import 'tag_input.dart';
import 'transaction_type_selector.dart';
import '../../../../l10n/app_localizations.dart';

/// A reusable form widget for creating and editing transactions.
/// Can be used in dialogs or inline in detail panes.
class TransactionEditForm extends StatefulWidget {
  final Transaction? transaction;
  final ValueChanged<Transaction> onSave;
  final VoidCallback? onCancel;
  final bool showActions;
  final ValueChanged<bool>? onFormValidChanged;

  const TransactionEditForm({
    this.transaction,
    required this.onSave,
    this.onCancel,
    this.showActions = true,
    this.onFormValidChanged,
    super.key,
  });

  @override
  State<TransactionEditForm> createState() => TransactionEditFormState();
}

class TransactionEditFormState extends State<TransactionEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  late TransactionType _type;
  late String? _accountId;
  late String? _categoryId;
  late String? _targetAccountId;
  late DateTime _createdAt;
  late DateTime? _effectiveDate;
  List<Tag> _selectedTags = [];
  Account? _selectedAccount;
  bool isFormValid = false;
  bool _isSaving = false;
  int _numberOfInstallments = 1;
  bool _isEditingLinkedTransaction = false;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;

    if (transaction != null) {
      // Check if this transaction is a linked transaction (has a parent)
      _isEditingLinkedTransaction = transaction.isLinkedTransaction;

      _accountId = transaction.accountId;
      _categoryId = transaction.categoryId;
      _targetAccountId = transaction.targetAccountId;
      _createdAt = transaction.createdAt;
      _effectiveDate = transaction.effectiveDate;
      _amountController.text = (transaction.amount.abs() / 100).toStringAsFixed(
        2,
      );
      _notesController.text = transaction.notes ?? '';
      _loadExistingTags(transaction.tagIds);
      _loadAccount(transaction.accountId);

      if (transaction.isTransfer) {
        _type = TransactionType.transfer;
      } else if (transaction.isExpense) {
        _type = TransactionType.expense;
      } else {
        _type = TransactionType.income;
      }
    } else {
      _type = TransactionType.expense;
      _accountId = null;
      _categoryId = null;
      _targetAccountId = null;
      _createdAt = DateTime.now();
      _effectiveDate = null;
      _selectedTags = [];
    }

    _amountController.addListener(_validateForm);
    // Validate initial state
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
  }

  Future<void> _loadExistingTags(List<String> tagIds) async {
    final tagsManager = getService<TagsManager>();
    final tags = await tagsManager.getTagsByIds(tagIds);
    setState(() {
      _selectedTags = tags;
    });
  }

  Future<void> _loadAccount(String accountId) async {
    final accountsManager = getService<AccountsManager>();
    final account = await accountsManager.getAccountById(accountId);
    if (mounted) {
      setState(() {
        _selectedAccount = account;
        // Set effective date to today if account supports it and no effective date is set
        if (_selectedAccount?.supportsEffectiveDate == true &&
            _effectiveDate == null) {
          _effectiveDate = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _amountController.removeListener(_validateForm);
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSaving) return; // Prevent double-saves

    setState(() => _isSaving = true);

    try {
      final amountText = _amountController.text.trim();
      final amountDouble = double.parse(amountText);
      int amount = (amountDouble * 100).round();
      if (_type == TransactionType.expense ||
          _type == TransactionType.transfer) {
        amount = -amount;
      }

      final tagIds = _selectedTags.map((tag) => tag.id).toList();

      // Get the account balance before creating the transaction
      int accountBalanceBefore;
      int? targetAccountBalanceBefore;

      if (widget.transaction != null) {
        // Editing existing transaction, keep original balance
        accountBalanceBefore = widget.transaction!.accountBalanceBefore;
        targetAccountBalanceBefore =
            widget.transaction!.targetAccountBalanceBefore;
      } else {
        // Creating new transaction, fetch current account balance
        final accountsManager = getService<AccountsManager>();
        final account = await accountsManager.getAccountById(_accountId!);
        accountBalanceBefore = account?.balance ?? 0;

        // For transfers, also get target account balance
        if (_type == TransactionType.transfer && _targetAccountId != null) {
          final targetAccount = await accountsManager.getAccountById(
            _targetAccountId!,
          );
          targetAccountBalanceBefore = targetAccount?.balance ?? 0;
        }
      }

      // Create the main transaction
      final transaction = Transaction.create(
        id: widget.transaction?.id,
        createdAt: _createdAt,
        accountId: _accountId!,
        categoryId: _type == TransactionType.transfer ? null : _categoryId,
        amount: amount,
        accountBalanceBefore: accountBalanceBefore,
        targetAccountId: _type == TransactionType.transfer
            ? _targetAccountId
            : null,
        targetAccountBalanceBefore: targetAccountBalanceBefore,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        tagIds: tagIds,
        effectiveDate: _effectiveDate,
      );

      // If creating new transaction with installments > 1, create linked transactions
      if (widget.transaction == null && _numberOfInstallments > 1) {
        // For multiple installments, divide the amount
        final installmentAmount = amount ~/ _numberOfInstallments;
        final remainder = amount % _numberOfInstallments;

        // Create a list to hold all transactions - first is the parent
        final List<Transaction> transactionsToCreate = [transaction];

        // Create child transactions
        for (int i = 1; i < _numberOfInstallments; i++) {
          final childAmount = i == _numberOfInstallments - 1
              ? installmentAmount + remainder
              : installmentAmount;

          // Each month, starting from the next month
          final childDate = _createdAt.add(Duration(days: 30 * i));

          final childTransaction = Transaction.create(
            createdAt: childDate,
            accountId: _accountId!,
            categoryId: _categoryId,
            amount: childAmount,
            accountBalanceBefore: 0,
            notes: _notesController.text.trim().isEmpty
                ? null
                : '${_notesController.text.trim()} (${i + 1}/$_numberOfInstallments)',
            tagIds: tagIds,
            parentTransactionId: transaction.id,
          );
          transactionsToCreate.add(childTransaction);
        }

        // Return all transactions to be saved by parent handler
        // We need to modify onSave callback to handle multiple transactions
        // For now, we'll pass them one by one, starting with the parent
        widget.onSave(transaction);
        for (int i = 1; i < transactionsToCreate.length; i++) {
          widget.onSave(transactionsToCreate[i]);
        }
      } else {
        widget.onSave(transaction);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizing.dialogMaxWidth),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Transaction type selector
              Align(
                alignment: Alignment.center,
                child: TransactionTypeSelector(
                  type: _type,
                  onChanged: (TransactionType newType) {
                    setState(() {
                      _type = newType;
                      if (_type == TransactionType.transfer) {
                        _categoryId = null;
                      } else {
                        _targetAccountId = null;
                      }
                      _validateForm();
                    });
                  },
                ),
              ),

              // Date and time picker
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppSizing.inputWidthSm),
                child: DateTimePickerField(
                  dateTime: _createdAt,
                  label: l10n.transactionDateLabel,
                  onChanged: (DateTime newDateTime) {
                    setState(() {
                      _createdAt = newDateTime;
                    });
                  },
                ),
              ),

              // Amount field
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppSizing.inputWidthSm),
                child: CurrencyInputField(
                  controller: _amountController,
                  label: l10n.transactionAmountLabel,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.transactionAmountRequired;
                    }
                    final amountDouble = double.tryParse(value);
                    if (amountDouble == null || amountDouble <= 0) {
                      return l10n.transactionAmountMustBePositive;
                    }
                    return null;
                  },
                ),
              ),

              // Effective Date field (only for expenses if account supports it)
              if (_type == TransactionType.expense &&
                  _selectedAccount?.supportsEffectiveDate == true &&
                  _effectiveDate != null)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppSizing.inputWidthSm),
                  child: DatePickerField(
                    date: _effectiveDate!,
                    label: l10n.transactionEffectiveDateLabel,
                    onChanged: (DateTime newDate) {
                      setState(() {
                        _effectiveDate = newDate;
                      });
                    },
                  ),
                ),

              // Installments field (only for new expenses if account supports it)
              if (_type == TransactionType.expense &&
                  _selectedAccount?.supportsInstallments == true &&
                  widget.transaction == null)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppSizing.inputWidthSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(
                        l10n.transactionInstallmentsLabel,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SegmentedButton<int>(
                        segments: List<ButtonSegment<int>>.generate(
                          12,
                          (index) => ButtonSegment<int>(
                            value: index + 1,
                            label: Text('${index + 1}'),
                          ),
                        ),
                        selected: {_numberOfInstallments},
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() {
                            _numberOfInstallments = newSelection.first;
                          });
                        },
                        showSelectedIcon: false,
                      ),
                      if (_numberOfInstallments > 1)
                        Text(
                          l10n.transactionInstallmentsHelper,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                    ],
                  ),
                ),

              // Linked transaction info
              if (_isEditingLinkedTransaction)
                Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppSizing.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.sm,
                    children: [
                      Row(
                        children: [
                          AppIcons.info,
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              l10n.editParentTransactionMessage,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Account selector
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppSizing.inputWidthMd,
                    ),
                    child: AccountSelector(
                      accountId: _accountId,
                      label: _type == TransactionType.transfer
                          ? l10n.transactionSourceAccountLabel
                          : null,
                      onChanged: (accountId) {
                        setState(() {
                          _accountId = accountId;
                          _validateForm();
                        });
                        _loadAccount(accountId);
                      },
                      validator: (accountId) {
                        if (accountId == null || accountId.isEmpty) {
                          return l10n.transactionAccountRequired;
                        }
                        return null;
                      },
                    ),
                  ),

                  // Category selector (only for expense/income)
                  if (_type != TransactionType.transfer)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppSizing.inputWidthMd,
                      ),
                      child: CategorySelector(
                        categoryId: _categoryId,
                        transactionType: _type,
                        onChanged: (categoryId) {
                          setState(() {
                            _categoryId = categoryId;
                          });
                        },
                      ),
                    ),

                  // Target account selector (only for transfer)
                  if (_type == TransactionType.transfer)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppSizing.inputWidthMd,
                      ),
                      child: AccountSelector(
                        accountId: _targetAccountId,
                        label: l10n.transactionTargetAccountLabel,
                        onChanged: (accountId) {
                          setState(() {
                            _targetAccountId = accountId;
                            _validateForm();
                          });
                        },
                        validator: (accountId) {
                          if (accountId == null || accountId.isEmpty) {
                            return l10n.transactionTargetAccountRequired;
                          }
                          if (accountId == _accountId) {
                            return l10n.transactionTargetAccountSameError;
                          }
                          return null;
                        },
                      ),
                    ),
                ],
              ),

              // Tags field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  if (_selectedTags.isNotEmpty)
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: _selectedTags.map((tag) {
                        return Chip(
                          label: Text(tag.name),
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          deleteIcon: AppIcons.close,
                          onDeleted: () => _removeTag(tag),
                          padding: AppSpacing.paddingHorizontalXs,
                        );
                      }).toList(),
                    ),
                  TagInput(
                    onAddTag: _addTag,
                    excludedIds: _selectedTags.map((t) => t.id).toList(),
                  ),
                ],
              ),

              // Notes field
              DescriptionInput(
                controller: _notesController,
                labelText: l10n.transactionNotesLabel,
                hintText: l10n.transactionNotesHint,
              ),

              // Actions
              if (widget.showActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: AppSpacing.sm,
                  children: [
                    if (widget.onCancel != null)
                      TextButton(
                        onPressed: _isSaving ? null : widget.onCancel,
                        child: Text(l10n.cancel),
                      ),
                    FilledButton(
                      onPressed: (isFormValid && !_isSaving)
                          ? handleSave
                          : null,
                      child: _isSaving
                          ? const SizedBox(
                              width: AppSizing.iconSm,
                              height: AppSizing.iconSm,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: AppSizing.radiusXs / 2,
                              ),
                            )
                          : Text(l10n.save),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    final hasAmount =
        _amountController.text.trim().isNotEmpty &&
        (double.tryParse(_amountController.text.trim()) ?? 0) > 0;
    final hasAccount = _accountId != null && _accountId!.isNotEmpty;
    final hasTargetAccountIfNeeded =
        _type != TransactionType.transfer ||
        (_targetAccountId != null &&
            _targetAccountId!.isNotEmpty &&
            _targetAccountId != _accountId);

    final isValid = hasAmount && hasAccount && hasTargetAccountIfNeeded;

    if (isValid != isFormValid) {
      setState(() {
        isFormValid = isValid;
      });
      widget.onFormValidChanged?.call(isValid);
    }
  }

  Future<void> _addTag(String tagName) async {
    final trimmedName = tagName.trim();
    if (trimmedName.isEmpty) return;

    final tagsManager = getService<TagsManager>();
    try {
      final tag = await tagsManager.getOrCreateTag(trimmedName);
      if (!_selectedTags.any((t) => t.id == tag.id)) {
        setState(() {
          _selectedTags.add(tag);
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppL10n.of(context);
        SnackAlert.error(
          context,
          message: l10n.errorCreatingTagMessage(e.toString()),
        );
      }
    }
  }

  void _removeTag(Tag tag) {
    setState(() {
      _selectedTags.removeWhere((t) => t.id == tag.id);
    });
  }
}
