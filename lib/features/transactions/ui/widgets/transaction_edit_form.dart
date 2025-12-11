import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/currency_input_field.dart';
import '../../../../core/ui/widgets/date_time_picker_field.dart';
import '../../../tags/application/tags_manager.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../domain/entities/transaction.dart';
import 'account_selector.dart';
import 'category_selector.dart';
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
  final _tagInputController = TextEditingController();

  late TransactionType _type;
  late String? _accountId;
  late String? _categoryId;
  late String? _targetAccountId;
  late DateTime _createdAt;
  List<Tag> _selectedTags = [];
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;

    if (transaction != null) {
      _accountId = transaction.accountId;
      _categoryId = transaction.categoryId;
      _targetAccountId = transaction.targetAccountId;
      _createdAt = transaction.createdAt;
      _amountController.text = (transaction.amount.abs() / 100).toStringAsFixed(
        2,
      );
      _notesController.text = transaction.notes ?? '';
      _loadExistingTags(transaction.tagIds);

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

  @override
  void dispose() {
    _amountController.removeListener(_validateForm);
    _amountController.dispose();
    _notesController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  void handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amountText = _amountController.text.trim();
    final amountDouble = double.parse(amountText);
    int amount = (amountDouble * 100).round();
    if (_type == TransactionType.expense) {
      amount = -amount;
    }

    final tagIds = _selectedTags.map((tag) => tag.id).toList();

    final transaction = Transaction.create(
      id: widget.transaction?.id,
      createdAt: _createdAt,
      accountId: _accountId!,
      categoryId: _type == TransactionType.transfer ? null : _categoryId,
      amount: amount,
      accountBalanceBefore: widget.transaction?.accountBalanceBefore ?? 0,
      targetAccountId: _type == TransactionType.transfer
          ? _targetAccountId
          : null,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      tagIds: tagIds,
    );

    widget.onSave(transaction);
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

              // Notes field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: l10n.transactionNotesLabel,
                  hintText: l10n.transactionNotesHint,
                ),
                maxLength: 200,
                maxLines: 2,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                        );
                      }).toList(),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tagInputController,
                          decoration: InputDecoration(
                            labelText: l10n.transactionTagsLabel,
                            hintText: l10n.transactionTagsHint,
                          ),
                          onFieldSubmitted: _addTag,
                        ),
                      ),
                      AppSpacing.gapHorizontalSm,
                      FilledButton.icon(
                        onPressed: () => _addTag(_tagInputController.text),
                        icon: AppIcons.add,
                        label: Text(l10n.add),
                      ),
                    ],
                  ),
                ],
              ),

              // Actions
              if (widget.showActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: AppSpacing.sm,
                  children: [
                    if (widget.onCancel != null)
                      TextButton(
                        onPressed: widget.onCancel,
                        child: Text(l10n.cancel),
                      ),
                    FilledButton(
                      onPressed: isFormValid ? handleSave : null,
                      child: Text(l10n.save),
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
      _tagInputController.clear();
    } catch (e) {
      if (mounted) {
        final l10n = AppL10n.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorCreatingTagMessage(e.toString()))),
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
