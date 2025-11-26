import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon_editor.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class CategoryEditDialog extends StatefulWidget {
  final Category category;
  final void Function(Category updatedCategory) onSave;

  const CategoryEditDialog({
    required this.category,
    required this.onSave,
    super.key,
  });

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late ObjectIconData _iconData;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(
      text: widget.category.description ?? '',
    );
    _iconData = widget.category.iconData;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AlertDialog(
      title: Text(l10n.categoriesEditTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.categoriesEditName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.categoriesEditNameRequired;
                  }
                  return null;
                },
              ),
              AppSpacing.gapVerticalMd,
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.categoriesEditDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              AppSpacing.gapVerticalMd,
              // Icon editor
              ObjectIconEditor(
                initialData: _iconData,
                onChanged: (data) {
                  setState(() {
                    _iconData = data;
                  });
                },
                iconLabel: l10n.categoriesEditIcon,
                iconHint: l10n.categoriesEditIconHelper,
                backgroundColorLabel: l10n.categoriesEditBackgroundColor,
                iconColorLabel: l10n.categoriesEditIconColor,
                colorHint: l10n.categoriesEditColorHelper,
                iconValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.categoriesEditIconRequired;
                  }
                  return null;
                },
                colorValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.categoriesEditColorRequired;
                  }
                  if (!_isValidHexColor(value)) {
                    return l10n.categoriesEditColorInvalid;
                  }
                  return null;
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

  bool _isValidHexColor(String value) {
    final hex = value.replaceAll('#', '');
    return RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex) ||
        RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(hex);
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedCategory = widget.category.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        iconData: _iconData,
      );
      Navigator.of(context).pop();
      widget.onSave(updatedCategory);
    }
  }
}
