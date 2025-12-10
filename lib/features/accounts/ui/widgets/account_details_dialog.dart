import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../domain/entities/account.dart';
import 'account_details_view.dart';
import '../../../../l10n/app_localizations.dart';

class AccountDetailsDialog extends StatelessWidget {
  final Account account;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const AccountDetailsDialog({
    required this.account,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AppDialog(
      iconData: account.iconData,
      title: account.name,
      content: AccountDetailsView(account: account),
      contentHeight: 200,
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          icon: AppIcons.delete,
          label: Text(l10n.delete),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onDuplicate();
          },
          icon: AppIcons.copy,
          label: Text(l10n.duplicate),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit();
          },
          icon: AppIcons.edit,
          label: Text(l10n.edit),
        ),
      ],
    );
  }
}
