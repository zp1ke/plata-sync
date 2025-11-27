import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/color_picker_field.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class ObjectIconEditor extends StatefulWidget {
  final ObjectIconData initialData;
  final ValueChanged<ObjectIconData> onChanged;

  const ObjectIconEditor({
    required this.initialData,
    required this.onChanged,
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
        AppSpacing.gapVerticalLg,
        // Icon selector
        DropdownButtonFormField<String>(
          initialValue: _selectedIconName,
          decoration: InputDecoration(
            labelText: l10n.categoriesEditIcon,
            border: const OutlineInputBorder(),
          ),
          items: AppIcons.iconDataMap.keys.map((String iconName) {
            return DropdownMenuItem<String>(
              value: iconName,
              child: Row(
                children: [
                  AppIcons.getIcon(iconName, size: AppSizing.iconMd),
                  AppSpacing.gapHorizontalMd,
                  Text(AppIcons.getIconLabel(iconName, l10n)),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedIconName = newValue;
              });
              _notifyChange();
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.categoriesEditIconRequired;
            }
            return null;
          },
        ),
        AppSpacing.gapVerticalMd,
        // Color fields in a row
        Row(
          children: [
            Expanded(
              child: ColorPickerField(
                label: l10n.categoriesEditBackgroundColor,
                value: _backgroundColor,
                onChanged: (color) {
                  setState(() {
                    _backgroundColor = color;
                  });
                  _notifyChange();
                },
              ),
            ),
            AppSpacing.gapHorizontalMd,
            Expanded(
              child: ColorPickerField(
                label: l10n.categoriesEditIconColor,
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
