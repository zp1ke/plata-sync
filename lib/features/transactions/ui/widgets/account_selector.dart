import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/input_decoration.dart';
import '../../../../core/ui/widgets/object_icon.dart';
import '../../../../core/ui/widgets/select_field.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../../l10n/app_localizations.dart';

/// A widget that allows selecting an account from available accounts
class AccountSelector extends StatelessWidget {
  final String? accountId;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? label;

  const AccountSelector({
    required this.accountId,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final labelText = label ?? l10n.transactionAccountLabel;
    final manager = getService<AccountsManager>();

    return ValueListenableBuilder<List<Account>>(
      valueListenable: manager.accounts,
      builder: (context, accounts, _) {
        if (accounts.isEmpty) {
          return TextFormField(
            enabled: false,
            decoration: inputDecorationWithPrefixIcon(
              labelText: labelText,
              hintText: l10n.accountsEmptyState,
              prefixIcon: AppIcons.accountsOutlinedXs,
            ),
          );
        }

        final selectedAccount = accounts
            .where((account) => account.id == accountId)
            .firstOrNull;

        return SelectField<Account>(
          value: selectedAccount,
          options: accounts,
          label: labelText,
          itemBuilder: (account) => Row(
            children: [
              ObjectIcon(iconData: account.iconData, size: AppSizing.iconMd),
              AppSpacing.gapHorizontalMd,
              Text(account.name, overflow: TextOverflow.ellipsis),
            ],
          ),
          onChanged: (account) => onChanged(account.id),
          validator: (account) => validator?.call(account?.id),
          enabled: enabled,
          searchFilter: (account, query) =>
              account.name.toLowerCase().contains(query.toLowerCase()),
        );
      },
    );
  }
}
