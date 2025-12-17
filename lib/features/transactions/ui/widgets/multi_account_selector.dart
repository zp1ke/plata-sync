import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../core/ui/widgets/input_decoration.dart';
import '../../../../core/ui/widgets/object_icon.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../../l10n/app_localizations.dart';

/// A widget that allows selecting multiple accounts from available accounts
class MultiAccountSelector extends StatefulWidget {
  final List<String>? accountIds;
  final ValueChanged<List<String>> onChanged;
  final String? Function(List<Account>?)? validator;
  final bool enabled;
  final String? label;

  const MultiAccountSelector({
    required this.accountIds,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.label,
    super.key,
  });

  @override
  State<MultiAccountSelector> createState() => _MultiAccountSelectorState();
}

class _MultiAccountSelectorState extends State<MultiAccountSelector> {
  @override
  void initState() {
    super.initState();
    // Load accounts when the selector is first created
    final manager = getService<AccountsManager>();
    if (manager.accounts.value.isEmpty) {
      manager.loadAccounts();
    }
  }

  void _showAccountDialog(BuildContext context, List<Account> allAccounts) {
    final selectedIds = Set<String>.from(widget.accountIds ?? []);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final l10n = AppL10n.of(context);
            return AppDialog(
              title: widget.label ?? l10n.transactionAccountLabel,
              scrollable: false,
              content: allAccounts.isEmpty
                  ? Center(
                      child: Text(
                        l10n.accountsAddSampleDataPrompt,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allAccounts.length,
                      itemBuilder: (context, index) {
                        final account = allAccounts[index];
                        final isSelected = selectedIds.contains(account.id);
                        return CheckboxListTile(
                          title: Row(
                            children: [
                              ObjectIcon(
                                iconData: account.iconData,
                                size: AppSizing.iconMd,
                              ),
                              AppSpacing.gapHorizontalMd,
                              Expanded(
                                child: Text(
                                  account.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          value: isSelected,
                          onChanged: (checked) {
                            setDialogState(() {
                              if (checked == true) {
                                selectedIds.add(account.id);
                              } else {
                                selectedIds.remove(account.id);
                              }
                            });
                          },
                        );
                      },
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    widget.onChanged(selectedIds.toList());
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final labelText = widget.label ?? l10n.transactionAccountLabel;
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

        final selectedAccounts = accounts
            .where(
              (account) => widget.accountIds?.contains(account.id) ?? false,
            )
            .toList();

        final displayText = selectedAccounts.isEmpty
            ? l10n.selectAccounts
            : selectedAccounts.map((a) => a.name).join(', ');

        return InkWell(
          onTap: widget.enabled
              ? () => _showAccountDialog(context, accounts)
              : null,
          child: InputDecorator(
            decoration: inputDecorationWithPrefixIcon(
              labelText: labelText,
              prefixIcon: AppIcons.accountsOutlinedXs,
            ),
            child: Text(
              displayText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selectedAccounts.isEmpty
                    ? Theme.of(context).hintColor
                    : null,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }
}
