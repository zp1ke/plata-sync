import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/color_picker_field.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/ui/widgets/select_field.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

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
  late String _selectedIconName;
  late String _backgroundColor;
  late String _iconColor;

  @override
  void initState() {
    super.initState();
    _selectedIconName = widget.initialData.iconName;
    _backgroundColor = widget.initialData.backgroundColorHex;
    _iconColor = widget.initialData.iconColorHex;
  }

  void _notifyChange() {
    widget.onChanged(
      ObjectIconData(
        iconName: _selectedIconName,
        backgroundColorHex: _backgroundColor,
        iconColorHex: _iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.lg,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Wrap(
          alignment: WrapAlignment.start,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          runAlignment: WrapAlignment.start,
          children: [
            // Icon selector
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppSizing.avatarLg * 6),
              child: SelectField<String>(
                value: _selectedIconName,
                options: AppIcons.iconDataMap.keys.toList(),
                label: widget.iconLabel,
                itemLabelBuilder: (iconName) =>
                    AppIcons.getIconLabel(iconName, l10n),
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
                  _notifyChange();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.iconRequiredMessage;
                  }
                  return null;
                },
              ),
            ),
            // Background color picker
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizing.avatarLg * 3,
              ),
              child: ColorPickerField(
                label: widget.backgroundColorLabel,
                value: _backgroundColor,
                onChanged: (color) {
                  setState(() {
                    _backgroundColor = color;
                  });
                  _notifyChange();
                },
              ),
            ),
            // Icon color picker
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizing.avatarLg * 3,
              ),
              child: ColorPickerField(
                label: widget.iconColorLabel,
                value: _iconColor,
                onChanged: (color) {
                  setState(() {
                    _iconColor = color;
                  });
                  _notifyChange();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
