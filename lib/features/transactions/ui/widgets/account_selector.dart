import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/ui/widgets/select_field.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A widget that allows selecting an account from available accounts
class AccountSelector extends StatefulWidget {
  final String? accountId;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const AccountSelector({
    required this.accountId,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    super.key,
  });

  @override
  State<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  late final AccountsManager _manager;
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _manager = getService<AccountsManager>();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    await _manager.loadAccounts();
    if (mounted) {
      setState(() {
        _accounts = _manager.accounts.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    if (_accounts.isEmpty) {
      return TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: l10n.accountsScreenTitle,
          hintText: l10n.accountsEmptyState,
          border: const OutlineInputBorder(),
        ),
      );
    }

    final selectedAccount = _accounts.cast<Account?>().firstWhere(
      (account) => account?.id == widget.accountId,
      orElse: () => null,
    );

    return SelectField<Account>(
      value: selectedAccount,
      options: _accounts,
      label: l10n.accountsScreenTitle,
      itemLabelBuilder: (account) => account.name,
      itemBuilder: (account) => Row(
        children: [
          ObjectIcon(iconData: account.iconData, size: AppSizing.iconMd),
          AppSpacing.gapHorizontalMd,
          Expanded(child: Text(account.name, overflow: TextOverflow.ellipsis)),
        ],
      ),
      onChanged: (account) => widget.onChanged(account.id),
      validator: (account) => widget.validator?.call(account?.id),
      enabled: widget.enabled,
    );
  }
}
