import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/currency_input_field.dart';
import 'package:plata_sync/core/ui/widgets/object_icon_editor.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A reusable form widget for creating and editing accounts.
/// Can be used in dialogs or inline in detail panes.
class AccountEditForm extends StatefulWidget {
  final Account? account;
  final void Function(Account account) onSave;
  final VoidCallback? onCancel;
  final bool showActions;
  final ValueChanged<bool>? onFormValidChanged;

  const AccountEditForm({
    this.account,
    required this.onSave,
    this.onCancel,
    this.showActions = true,
    this.onFormValidChanged,
    super.key,
  });

  @override
  State<AccountEditForm> createState() => AccountEditFormState();
}

class AccountEditFormState extends State<AccountEditForm> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController balanceController;
  late ObjectIconData iconData;
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.account?.name ?? '');
    descriptionController = TextEditingController(
      text: widget.account?.description ?? '',
    );
    // Only show balance for new accounts
    balanceController = TextEditingController(
      text: widget.account == null ? '0.00' : '',
    );
    iconData =
        widget.account?.iconData ??
        const ObjectIconData(
          iconName: 'account_balance',
          backgroundColorHex: 'E3F2FD',
          iconColorHex: '2196F3',
        );

    nameController.addListener(_validateForm);
    balanceController.addListener(_validateForm);
    // Validate initial state
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
  }

  @override
  void dispose() {
    nameController.removeListener(_validateForm);
    balanceController.removeListener(_validateForm);
    nameController.dispose();
    descriptionController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final isCreating = widget.account == null;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            // Name field
            TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: AppIcons.accountsOutlined,
                labelText: '${l10n.accountsEditName} *',
                border: const OutlineInputBorder(),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.accountsEditNameRequired;
                }
                return null;
              },
            ),
            // Description field
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                prefixIcon: AppIcons.description,
                labelText: '${l10n.accountsEditDescription} (${l10n.optional})',
                border: const OutlineInputBorder(),
              ),
              maxLength: 300,
              maxLines: 3,
            ),
            // Initial Balance field (only for creation)
            if (isCreating)
              CurrencyInputField(
                controller: balanceController,
                label: l10n.accountsEditInitialBalance,
                helperText: l10n.accountsEditInitialBalanceHelper,
                required: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.accountsEditInitialBalanceRequired;
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null) {
                    return l10n.accountsEditInitialBalanceInvalid;
                  }
                  return null;
                },
              ),
            // Icon editor
            ObjectIconEditor(
              initialData: iconData,
              iconLabel: l10n.accountsEditIcon,
              iconRequiredMessage: l10n.accountsEditIconRequired,
              backgroundColorLabel: l10n.accountsEditBackgroundColor,
              iconColorLabel: l10n.accountsEditIconColor,
              onChanged: (data) {
                setState(() {
                  iconData = data;
                });
              },
            ),
            // Actions (optional - for inline use)
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
    );
  }

  void handleSave() {
    if (formKey.currentState?.validate() ?? false) {
      // Convert balance to cents
      final balanceInCents = widget.account == null
          ? (double.parse(balanceController.text.trim()) * 100).round()
          : widget.account!.balance;

      final account = widget.account != null
          ? widget.account!.copyWith(
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
              iconData: iconData,
            )
          : Account.create(
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
              iconData: iconData,
              balance: balanceInCents,
            );
      widget.onSave(account);
    }
  }

  void _validateForm() {
    final newIsValid = formKey.currentState?.validate() ?? false;
    if (newIsValid != isFormValid) {
      setState(() {
        isFormValid = newIsValid;
      });
      widget.onFormValidChanged?.call(newIsValid);
    }
  }
}
