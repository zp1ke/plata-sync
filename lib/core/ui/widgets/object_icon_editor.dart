import 'package:flutter/material.dart';
import '../../model/object_icon_data.dart';
import '../resources/app_icons.dart';
import '../resources/app_sizing.dart';
import '../resources/app_spacing.dart';
import 'color_picker_field.dart';
import 'object_icon.dart';
import 'select_field.dart';
import '../../../l10n/app_localizations.dart';

class ObjectIconEditor extends StatefulWidget {
  final ObjectIconData initialData;
  final ValueChanged<ObjectIconData> onChanged;
  final String iconLabel;
  final String iconRequiredMessage;
  final String backgroundColorLabel;
  final String iconColorLabel;

  const ObjectIconEditor({
    required this.initialData,
    required this.onChanged,
    required this.iconLabel,
    required this.iconRequiredMessage,
    required this.backgroundColorLabel,
    required this.iconColorLabel,
    super.key,
  });

  @override
  State<ObjectIconEditor> createState() => _ObjectIconEditorState();
}

class _ObjectIconEditorState extends State<ObjectIconEditor> {
  late ObjectIconData _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData;
  }

  Future<void> _showEditorDialog() async {
    final result = await showDialog<ObjectIconData>(
      context: context,
      builder: (context) => _ObjectIconEditorDialog(
        initialData: _currentData,
        iconLabel: widget.iconLabel,
        iconRequiredMessage: widget.iconRequiredMessage,
        backgroundColorLabel: widget.backgroundColorLabel,
        iconColorLabel: widget.iconColorLabel,
      ),
    );

    if (result != null) {
      setState(() {
        _currentData = result;
      });
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: _showEditorDialog,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: AppSizing.avatarXl,
        height: AppSizing.avatarXl,
        child: Stack(
          children: [
            ObjectIcon.raw(
              iconName: _currentData.iconName,
              backgroundColorHex: _currentData.backgroundColorHex,
              iconColorHex: _currentData.iconColorHex,
              size: AppSizing.avatarXl,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: AppIcons.editSm(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ObjectIconEditorDialog extends StatefulWidget {
  final ObjectIconData initialData;
  final String iconLabel;
  final String iconRequiredMessage;
  final String backgroundColorLabel;
  final String iconColorLabel;

  const _ObjectIconEditorDialog({
    required this.initialData,
    required this.iconLabel,
    required this.iconRequiredMessage,
    required this.backgroundColorLabel,
    required this.iconColorLabel,
  });

  @override
  State<_ObjectIconEditorDialog> createState() =>
      _ObjectIconEditorDialogState();
}

class _ObjectIconEditorDialogState extends State<_ObjectIconEditorDialog> {
  late String _selectedIconName;
  late String _backgroundColor;
  late String _iconColor;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedIconName = widget.initialData.iconName;
    _backgroundColor = widget.initialData.backgroundColorHex;
    _iconColor = widget.initialData.iconColorHex;
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(
        ObjectIconData(
          iconName: _selectedIconName,
          backgroundColorHex: _backgroundColor,
          iconColorHex: _iconColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AlertDialog(
      title: Text(l10n.editIcon),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preview
              Center(
                child: ObjectIcon.raw(
                  iconName: _selectedIconName,
                  backgroundColorHex: _backgroundColor,
                  iconColorHex: _iconColor,
                  size: AppSizing.avatarXl,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Icon selector
              SelectField<String>(
                value: _selectedIconName,
                options: AppIcons.iconDataMap.keys.toList(),
                label: widget.iconLabel,
                itemBuilder: (iconName) => Row(
                  spacing: AppSpacing.md,
                  children: [
                    AppIcons.getIcon(iconName, size: AppSizing.iconMd),
                    Expanded(
                      child: Text(
                        AppIcons.getIconLabel(iconName, l10n),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _selectedIconName = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.iconRequiredMessage;
                  }
                  return null;
                },
                searchFilter: (iconName, query) => AppIcons.getIconLabel(
                  iconName,
                  l10n,
                ).toLowerCase().contains(query.toLowerCase()),
              ),
              const SizedBox(height: AppSpacing.md),
              // Background color picker
              ColorPickerField(
                label: widget.backgroundColorLabel,
                value: _backgroundColor,
                onChanged: (color) {
                  setState(() {
                    _backgroundColor = color;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Icon color picker
              ColorPickerField(
                label: widget.iconColorLabel,
                value: _iconColor,
                onChanged: (color) {
                  setState(() {
                    _iconColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _handleSave, child: Text(l10n.save)),
      ],
    );
  }
}
