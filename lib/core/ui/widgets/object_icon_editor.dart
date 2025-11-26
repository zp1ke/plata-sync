import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/utils/colors.dart';
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
  late TextEditingController _iconController;
  late TextEditingController _backgroundColorController;
  late TextEditingController _iconColorController;

  @override
  void initState() {
    super.initState();
    _iconController = TextEditingController(text: widget.initialData.iconName);
    _backgroundColorController = TextEditingController(
      text: widget.initialData.backgroundColorHex,
    );
    _iconColorController = TextEditingController(
      text: widget.initialData.iconColorHex,
    );

    _iconController.addListener(_notifyChange);
    _backgroundColorController.addListener(_notifyChange);
    _iconColorController.addListener(_notifyChange);
  }

  @override
  void dispose() {
    _iconController.removeListener(_notifyChange);
    _backgroundColorController.removeListener(_notifyChange);
    _iconColorController.removeListener(_notifyChange);
    _iconController.dispose();
    _backgroundColorController.dispose();
    _iconColorController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(
      ObjectIconData(
        iconName: _iconController.text,
        backgroundColorHex: _backgroundColorController.text,
        iconColorHex: _iconColorController.text,
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
            iconName: _iconController.text.isNotEmpty
                ? _iconController.text
                : widget.initialData.iconName,
            backgroundColorHex: _backgroundColorController.text.isNotEmpty
                ? _backgroundColorController.text
                : widget.initialData.backgroundColorHex,
            iconColorHex: _iconColorController.text.isNotEmpty
                ? _iconColorController.text
                : widget.initialData.iconColorHex,
            size: AppSizing.avatarXl,
          ),
        ),
        AppSpacing.gapVerticalLg,
        // Icon field
        TextFormField(
          controller: _iconController,
          decoration: InputDecoration(
            labelText: l10n.categoriesEditIcon,
            border: const OutlineInputBorder(),
            helperText: l10n.categoriesEditIconHelper,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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
              child: TextFormField(
                controller: _backgroundColorController,
                decoration: InputDecoration(
                  labelText: l10n.categoriesEditBackgroundColor,
                  border: const OutlineInputBorder(),
                  helperText: l10n.categoriesEditColorHelper,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: ColorExtensions.fromHex(
                          _backgroundColorController.text,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.categoriesEditColorRequired;
                  }
                  if (!ColorExtensions.isValidHex(value)) {
                    return l10n.categoriesEditColorInvalid;
                  }
                  return null;
                },
              ),
            ),
            AppSpacing.gapHorizontalMd,
            Expanded(
              child: TextFormField(
                controller: _iconColorController,
                decoration: InputDecoration(
                  labelText: l10n.categoriesEditIconColor,
                  border: const OutlineInputBorder(),
                  helperText: l10n.categoriesEditColorHelper,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Container(
                      width: AppSizing.iconMd,
                      height: AppSizing.iconMd,
                      decoration: BoxDecoration(
                        color: ColorExtensions.fromHex(
                          _iconColorController.text,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.categoriesEditColorRequired;
                  }
                  if (!ColorExtensions.isValidHex(value)) {
                    return l10n.categoriesEditColorInvalid;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
