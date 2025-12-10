import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../domain/entities/account.dart';
import 'account_edit_form.dart';
import '../../../../l10n/app_localizations.dart';

class AccountEditDialog extends StatelessWidget {
  final Account? account;
  final void Function(Account updatedAccount) onSave;

  const AccountEditDialog({this.account, required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AppDialog(
      title: account == null
          ? l10n.accountsCreateTitle
          : l10n.accountsEditTitle,
      contentHeight: 580,
      content: AccountEditForm(
        account: account,
        onSave: (updatedAccount) {
          Navigator.of(context).pop();
          onSave(updatedAccount);
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
