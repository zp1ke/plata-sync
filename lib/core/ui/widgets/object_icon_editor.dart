import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';

class ObjectIconEditor extends StatefulWidget {
  final ObjectIconData initialData;
  final ValueChanged<ObjectIconData> onChanged;
  final String? iconLabel;
  final String? iconHint;
  final String? backgroundColorLabel;
  final String? iconColorLabel;
  final String? colorHint;
  final String? Function(String?)? iconValidator;
  final String? Function(String?)? colorValidator;

  const ObjectIconEditor({
    required this.initialData,
    required this.onChanged,
    this.iconLabel,
    this.iconHint,
    this.backgroundColorLabel,
    this.iconColorLabel,
    this.colorHint,
    this.iconValidator,
    this.colorValidator,
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
            size: 64,
          ),
        ),
        AppSpacing.gapVerticalLg,
        // Icon field
        TextFormField(
          controller: _iconController,
          decoration: InputDecoration(
            labelText: widget.iconLabel ?? 'Icon',
            border: const OutlineInputBorder(),
            helperText: widget.iconHint,
          ),
          validator: widget.iconValidator,
        ),
        AppSpacing.gapVerticalMd,
        // Color fields in a row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _backgroundColorController,
                decoration: InputDecoration(
                  labelText: widget.backgroundColorLabel ?? 'Background Color',
                  border: const OutlineInputBorder(),
                  helperText: widget.colorHint,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            _parseColor(_backgroundColorController.text) ??
                            Colors.grey,
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
                validator: widget.colorValidator,
              ),
            ),
            AppSpacing.gapHorizontalMd,
            Expanded(
              child: TextFormField(
                controller: _iconColorController,
                decoration: InputDecoration(
                  labelText: widget.iconColorLabel ?? 'Icon Color',
                  border: const OutlineInputBorder(),
                  helperText: widget.colorHint,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            _parseColor(_iconColorController.text) ??
                            Colors.grey,
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
                validator: widget.colorValidator,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color? _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
