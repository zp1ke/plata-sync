import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/currency_input_field.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/features/transactions/ui/widgets/account_selector.dart';
import 'package:plata_sync/features/transactions/ui/widgets/category_selector.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

enum TransactionType { expense, income, transfer }

class TransactionEditForm extends StatefulWidget {
  final Transaction? transaction;
  final ValueChanged<Transaction> onSave;

  const TransactionEditForm({
    this.transaction,
    required this.onSave,
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
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final amountText = _amountController.text.trim();
    final amountDouble = double.parse(amountText);
    int amount = (amountDouble * 100).round();
    if (_type == TransactionType.expense) {
      amount = -amount;
    }

    final transaction = Transaction.create(
      id: widget.transaction?.id,
      createdAt: _createdAt,
      accountId: _accountId!,
      categoryId: _type == TransactionType.transfer ? null : _categoryId,
      amount: amount,
      targetAccountId: _type == TransactionType.transfer
          ? _targetAccountId
          : null,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
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
            spacing: AppSpacing.lg,
            children: [
              // Transaction type selector
              SegmentedButton<TransactionType>(
                segments: [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text(l10n.transactionTypeExpense),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text(l10n.transactionTypeIncome),
                  ),
                  ButtonSegment(
                    value: TransactionType.transfer,
                    label: Text(l10n.transactionTypeTransfer),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (Set<TransactionType> newSelection) {
                  setState(() {
                    _type = newSelection.first;
                    if (_type == TransactionType.transfer) {
                      _categoryId = null;
                    } else {
                      _targetAccountId = null;
                    }
                  });
                },
              ),

              // Date and time picker
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _createdAt,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null && context.mounted) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_createdAt),
                    );
                    if (time != null) {
                      setState(() {
                        _createdAt = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.transactionDateLabel,
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    '${l10n.transactionDateFormat(_createdAt)} ${TimeOfDay.fromDateTime(_createdAt).format(context)}',
                  ),
                ),
              ),

              // Account selector
              AccountSelector(
                accountId: _accountId,
                onChanged: (accountId) {
                  setState(() {
                    _accountId = accountId;
                  });
                },
                validator: (accountId) {
                  if (accountId == null || accountId.isEmpty) {
                    return l10n.transactionAccountRequired;
                  }
                  return null;
                },
              ),

              // Category selector (only for expense/income)
              if (_type != TransactionType.transfer)
                CategorySelector(
                  categoryId: _categoryId,
                  onChanged: (categoryId) {
                    setState(() {
                      _categoryId = categoryId;
                    });
                  },
                ),

              // Target account selector (only for transfer)
              if (_type == TransactionType.transfer)
                AccountSelector(
                  accountId: _targetAccountId,
                  onChanged: (accountId) {
                    setState(() {
                      _targetAccountId = accountId;
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

              // Amount field
              CurrencyInputField(
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

              // Notes field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: l10n.transactionNotesLabel,
                  hintText: l10n.transactionNotesHint,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              // Save button
              FilledButton(onPressed: handleSave, child: Text(l10n.saveButton)),
            ],
          ),
        ),
      ),
    );
  }
}
