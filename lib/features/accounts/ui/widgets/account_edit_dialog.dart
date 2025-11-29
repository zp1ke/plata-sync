import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/accounts/ui/widgets/account_edit_form.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class AccountEditDialog extends StatelessWidget {
  final Account? account;
  final void Function(Account updatedAccount) onSave;

  const AccountEditDialog({this.account, required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AlertDialog(
      title: Text(
        account == null ? l10n.accountsCreateTitle : l10n.accountsEditTitle,
      ),
      content: SizedBox(
        width: AppSizing.dialogMaxWidth,
        child: SingleChildScrollView(
          child: AccountEditForm(
            account: account,
            onSave: (updatedAccount) {
              Navigator.of(context).pop();
              onSave(updatedAccount);
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}
