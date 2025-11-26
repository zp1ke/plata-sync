import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
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
  late final TextEditingController _iconController;
  late final TextEditingController _backgroundColorController;
  late final TextEditingController _iconColorController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(
      text: widget.category.description ?? '',
    );
    _iconController = TextEditingController(text: widget.category.icon);
    _backgroundColorController = TextEditingController(
      text: widget.category.backgroundColorHex,
    );
    _iconColorController = TextEditingController(
      text: widget.category.iconColorHex,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    _backgroundColorController.dispose();
    _iconColorController.dispose();
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
              // Preview
              ValueListenableBuilder(
                valueListenable: _iconController,
                builder: (context, iconValue, _) {
                  return ValueListenableBuilder(
                    valueListenable: _backgroundColorController,
                    builder: (context, bgColorValue, _) {
                      return ValueListenableBuilder(
                        valueListenable: _iconColorController,
                        builder: (context, iconColorValue, _) {
                          return Center(
                            child: ObjectIcon(
                              iconName: iconValue.text.isNotEmpty
                                  ? iconValue.text
                                  : widget.category.icon,
                              backgroundColorHex: bgColorValue.text.isNotEmpty
                                  ? bgColorValue.text
                                  : widget.category.backgroundColorHex,
                              iconColorHex: iconColorValue.text.isNotEmpty
                                  ? iconColorValue.text
                                  : widget.category.iconColorHex,
                              size: 64,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              AppSpacing.gapVerticalLg,
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
              // Background color field
              TextFormField(
                controller: _backgroundColorController,
                decoration: InputDecoration(
                  labelText: l10n.categoriesEditBackgroundColor,
                  border: const OutlineInputBorder(),
                  helperText: l10n.categoriesEditColorHelper,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.categoriesEditColorRequired;
                  }
                  if (!_isValidHexColor(value)) {
                    return l10n.categoriesEditColorInvalid;
                  }
                  return null;
                },
              ),
              AppSpacing.gapVerticalMd,
              // Icon color field
              TextFormField(
                controller: _iconColorController,
                decoration: InputDecoration(
                  labelText: l10n.categoriesEditIconColor,
                  border: const OutlineInputBorder(),
                  helperText: l10n.categoriesEditColorHelper,
                ),
                validator: (value) {
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
        icon: _iconController.text.trim(),
        backgroundColorHex: _backgroundColorController.text.trim(),
        iconColorHex: _iconColorController.text.trim(),
      );
      Navigator.of(context).pop();
      widget.onSave(updatedCategory);
    }
  }
}
