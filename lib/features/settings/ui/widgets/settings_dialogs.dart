import 'package:flutter/material.dart';

import '../../../../core/ui/widgets/dialog.dart';
import '../../../../l10n/app_localizations.dart';

/// Dialog to confirm data source change.
class DataSourceChangeConfirmDialog extends StatelessWidget {
  const DataSourceChangeConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AppDialog(
      title: l10n.settingsDataSourceChangeTitle,
      content: Text(l10n.settingsDataSourceChangeMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

/// Dialog to inform user about data source change requiring restart.
class DataSourceChangedDialog extends StatelessWidget {
  const DataSourceChangedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AppDialog(
      title: l10n.settingsDataSourceChangedTitle,
      content: Text(l10n.settingsDataSourceChangedMessage),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

/// Import mode selection for data import.
enum ImportMode { append, replace }

/// Dialog to select import mode (append or replace).
class ImportModeDialog extends StatefulWidget {
  const ImportModeDialog({super.key});

  @override
  State<ImportModeDialog> createState() => _ImportModeDialogState();
}

class _ImportModeDialogState extends State<ImportModeDialog> {
  ImportMode? _selectedMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return AppDialog(
      title: l10n.settingsImportModeTitle,
      content: RadioGroup<ImportMode>(
        groupValue: _selectedMode,
        onChanged: (value) => setState(() => _selectedMode = value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ImportMode>(
              value: ImportMode.append,
              title: Text(l10n.settingsImportModeAppend),
              subtitle: Text(
                l10n.settingsImportModeAppendDesc,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            RadioListTile<ImportMode>(
              value: ImportMode.replace,
              title: Text(l10n.settingsImportModeReplace),
              subtitle: Text(
                l10n.settingsImportModeReplaceDesc,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _selectedMode != null
              ? () => Navigator.of(context).pop(_selectedMode)
              : null,
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

/// Dialog to confirm clearing all data.
class ClearDataConfirmDialog extends StatelessWidget {
  const ClearDataConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AppDialog(
      title: l10n.settingsClearDataConfirmTitle,
      content: Text(l10n.settingsClearDataConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
