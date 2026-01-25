import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../core/data/csv/csv_file_saver.dart';
import '../../../../core/data/csv/transactions_csv_builder.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/enums/data_source_type.dart';
import '../../../../core/model/enums/date_format_type.dart';
import '../../../../core/model/enums/time_format_type.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/constrained_list_view.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../core/ui/widgets/responsive_layout.dart';
import '../../../../core/ui/widgets/snack_alert.dart';
import '../../../../core/utils/os.dart';
import '../../../accounts/data/interfaces/account_data_source.dart';
import '../../../categories/data/interfaces/category_data_source.dart';
import '../../../tags/data/interfaces/tag_data_source.dart';
import '../../../transactions/data/interfaces/transaction_data_source.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final settingsService = getService<SettingsService>();

    return ResponsiveLayout(
      mobile: (context) =>
          _MobileLayout(settingsService: settingsService, l10n: l10n),
      tabletOrLarger: (context) => MasterDetailLayout(
        masterWidthRatio: 0.4,
        master: Scaffold(
          appBar: AppBar(title: Text(l10n.settingsScreenTitle)),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppSizing.dialogMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeader(title: l10n.settingsSectionApp),
                  _AppIconWidget(),
                  ListTile(
                    leading: AppIcons.info,
                    title: Text(l10n.settingsAppVersion),
                    subtitle: Text(settingsService.getAppVersion()),
                  ),
                  ListTile(
                    leading: AppIcons.licenses,
                    title: Text(l10n.settingsLicenses),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: l10n.appTitle,
                      applicationVersion: settingsService.getAppVersion(),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  _SectionHeader(title: l10n.settingsSectionData),
                  const _DataSourceSetting(),
                  const _DataActions(),
                ],
              ),
            ),
          ),
        ),
        detail: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppSizing.dialogMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionHeader(title: l10n.settingsSectionDisplay),
                const _DateFormatSetting(),
                const _TimeFormatSetting(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final SettingsService settingsService;
  final AppL10n l10n;

  const _MobileLayout({required this.settingsService, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsScreenTitle)),
      body: ConstrainedListView(
        maxWidth: AppSizing.dialogMaxWidth,
        children: [
          // App Section
          _SectionHeader(title: l10n.settingsSectionApp),
          _AppIconWidget(),
          ListTile(
            leading: AppIcons.info,
            title: Text(l10n.settingsAppVersion),
            subtitle: Text(settingsService.getAppVersion()),
          ),
          ListTile(
            leading: AppIcons.licenses,
            title: Text(l10n.settingsLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationVersion: settingsService.getAppVersion(),
            ),
          ),
          const Divider(),

          // Data Section
          _SectionHeader(title: l10n.settingsSectionData),
          const _DataSourceSetting(),
          const _DataActions(),
          const Divider(),

          // Display Section
          _SectionHeader(title: l10n.settingsSectionDisplay),
          const _DateFormatSetting(),
          const _TimeFormatSetting(),
        ],
      ),
    );
  }
}

class _AppIconWidget extends StatelessWidget {
  const _AppIconWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizing.radiusXl),
        child: AppIcons.appIcon(context, size: AppSizing.iconXXl),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
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
        SnackAlert.error(context, message: e.toString());
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
    if (isMobilePlatform()) {
      Restart.restartApp(
        webOrigin: null,
        notificationTitle: l10n.restartingApp,
        notificationBody: l10n.settingsDataSourceChangedRestartingMessage,
      );
    } else if (isDesktopPlatform()) {
      // For desktop platforms, just show a dialog so user restart manually
      showDialog<void>(
        context: context,
        builder: (context) => AppDialog(
          title: l10n.settingsDataSourceChangedTitle,
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
      builder: (context) => AppDialog(
        title: l10n.settingsDataSourceChangeTitle,
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

class _DataActions extends StatefulWidget {
  const _DataActions();

  @override
  State<_DataActions> createState() => _DataActionsState();
}

class _DataActionsState extends State<_DataActions> {
  bool _isExporting = false;

  Future<void> _handleExport(BuildContext context) async {
    if (_isExporting) return;
    setState(() {
      _isExporting = true;
    });

    final l10n = AppL10n.of(context);

    try {
      final transactionDataSource = getService<TransactionDataSource>();
      final accountDataSource = getService<AccountDataSource>();
      final categoryDataSource = getService<CategoryDataSource>();
      final tagDataSource = getService<TagDataSource>();

      final transactions = await transactionDataSource.getAll();
      final accounts = await accountDataSource.getAll();
      final categories = await categoryDataSource.getAll();
      final tags = await tagDataSource.getAll();

      final csvContent = const TransactionsCsvBuilder().build(
        transactions: transactions,
        accounts: accounts,
        categories: categories,
        tags: tags,
      );

      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-');
      final fileName = 'plata_sync_export_$timestamp.csv';
      final result = await saveCsvFile(fileName: fileName, content: csvContent);

      if (context.mounted) {
        final message = result.isDownload
            ? l10n.settingsExportStarted
            : l10n.settingsExportSuccess;
        SnackAlert.success(context, message: message);
      }
    } catch (e) {
      if (context.mounted) {
        // Don't show error if user canceled
        if (e.toString().contains('canceled')) return;

        SnackAlert.error(
          context,
          message: l10n.settingsExportFailed(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return ListTile(
      leading: AppIcons.send,
      title: Text(l10n.settingsExportData),
      subtitle: Text(
        l10n.settingsExportDataDesc,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: _isExporting
          ? const SizedBox(
              width: AppSizing.iconSm,
              height: AppSizing.iconSm,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : null,
      enabled: !_isExporting,
      onTap: _isExporting ? null : () => _handleExport(context),
    );
  }
}

class _DateFormatSetting extends StatefulWidget {
  const _DateFormatSetting();

  @override
  State<_DateFormatSetting> createState() => _DateFormatSettingState();
}

class _DateFormatSettingState extends State<_DateFormatSetting> {
  late DateFormatType _selectedFormat;

  @override
  void initState() {
    super.initState();
    _selectedFormat = getService<SettingsService>().getDateFormat();
  }

  Future<void> _onFormatChanged(DateFormatType? newValue) async {
    if (newValue == null || newValue == _selectedFormat) return;

    setState(() {
      _selectedFormat = newValue;
    });

    try {
      final settingsService = getService<SettingsService>();
      await settingsService.setDateFormat(newValue);
    } catch (e) {
      if (mounted) {
        SnackAlert.error(context, message: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return RadioGroup<DateFormatType>(
      groupValue: _selectedFormat,
      onChanged: _onFormatChanged,
      child: Column(
        children: [
          RadioListTile<DateFormatType>(
            value: DateFormatType.long,
            secondary: AppIcons.calendar,
            title: Text(l10n.settingsDateFormatLong),
            subtitle: Text(
              l10n.settingsDateFormatLongExample,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          RadioListTile<DateFormatType>(
            value: DateFormatType.short,
            secondary: AppIcons.calendar,
            title: Text(l10n.settingsDateFormatShort),
            subtitle: Text(
              l10n.settingsDateFormatShortExample,
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

class _TimeFormatSetting extends StatefulWidget {
  const _TimeFormatSetting();

  @override
  State<_TimeFormatSetting> createState() => _TimeFormatSettingState();
}

class _TimeFormatSettingState extends State<_TimeFormatSetting> {
  late TimeFormatType _selectedFormat;

  @override
  void initState() {
    super.initState();
    _selectedFormat = getService<SettingsService>().getTimeFormat();
  }

  Future<void> _onFormatChanged(TimeFormatType? newValue) async {
    if (newValue == null || newValue == _selectedFormat) return;

    setState(() {
      _selectedFormat = newValue;
    });

    try {
      final settingsService = getService<SettingsService>();
      await settingsService.setTimeFormat(newValue);
    } catch (e) {
      if (mounted) {
        SnackAlert.error(context, message: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return RadioGroup<TimeFormatType>(
      groupValue: _selectedFormat,
      onChanged: _onFormatChanged,
      child: Column(
        children: [
          RadioListTile<TimeFormatType>(
            value: TimeFormatType.hour12,
            secondary: AppIcons.schedule,
            title: Text(l10n.settingsTimeFormat12h),
            subtitle: Text(
              l10n.settingsTimeFormat12hExample,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          RadioListTile<TimeFormatType>(
            value: TimeFormatType.hour24,
            secondary: AppIcons.schedule,
            title: Text(l10n.settingsTimeFormat24h),
            subtitle: Text(
              l10n.settingsTimeFormat24hExample,
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
