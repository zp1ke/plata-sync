import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/l10n/app_localizations.dart';
import 'package:restart_app/restart_app.dart';
import 'package:watch_it/watch_it.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final settingsService = getService<SettingsService>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsScreenTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizing.dialogMaxWidth),
          child: ListView(
            children: [
              // App Section
              _SectionHeader(title: l10n.settingsSectionApp),
              ListTile(
                leading: AppIcons.info,
                title: Text(l10n.settingsAppVersion),
                subtitle: Text(settingsService.getAppVersion()),
              ),
              const Divider(),

              // Data Section
              _SectionHeader(title: l10n.settingsSectionData),
              const _DataSourceSetting(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DataSourceSetting extends WatchingStatefulWidget {
  const _DataSourceSetting();

  @override
  State<_DataSourceSetting> createState() => _DataSourceSettingState();
}

class _DataSourceSettingState extends State<_DataSourceSetting> {
  late DataSourceType _selectedDataSource;
  bool _isChanging = false;

  @override
  void initState() {
    super.initState();
    _selectedDataSource = getService<SettingsService>().getDataSource();
  }

  Future<void> _onDataSourceChanged(DataSourceType? newValue) async {
    if (newValue == null || newValue == _selectedDataSource) return;

    final confirmed = await _showConfirmationDialog(context, newValue);
    if (!confirmed) return;

    setState(() {
      _isChanging = true;
    });

    try {
      final settingsService = getService<SettingsService>();
      await settingsService.setDataSource(newValue);

      if (mounted) {
        setState(() {
          _selectedDataSource = newValue;
        });

        restartApp();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChanging = false;
        });
      }
    }
  }

  void restartApp() {
    final l10n = AppL10n.of(context);
    if (Platform.isAndroid || Platform.isIOS) {
      Restart.restartApp(
        webOrigin: null,
        notificationTitle: l10n.restartingApp,
        notificationBody: l10n.settingsDataSourceChangedRestartingMessage,
      );
    } else {
      // For desktop platforms, just show a dialog so user restart manually
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: AppSpacing.paddingMd,
          title: Text(l10n.settingsDataSourceChangedTitle),
          content: Text(l10n.settingsDataSourceChangedMessage),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    DataSourceType newValue,
  ) async {
    final l10n = AppL10n.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: AppSpacing.paddingMd,
        title: Text(l10n.settingsDataSourceChangeTitle),
        content: Text(l10n.settingsDataSourceChangeMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return RadioGroup<DataSourceType>(
      groupValue: _selectedDataSource,
      onChanged: (DataSourceType? value) {
        if (!_isChanging && value != null) {
          _onDataSourceChanged(value);
        }
      },
      child: Column(
        children: [
          RadioListTile<DataSourceType>(
            value: DataSourceType.local,
            secondary: AppIcons.database,
            title: Text(l10n.settingsDataSourceLocal),
            subtitle: Text(
              l10n.settingsDataSourceLocalDesc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          RadioListTile<DataSourceType>(
            value: DataSourceType.inMemory,
            secondary: AppIcons.memory,
            title: Text(l10n.settingsDataSourceInMemory),
            subtitle: Text(
              l10n.settingsDataSourceInMemoryDesc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
