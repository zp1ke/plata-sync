import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
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
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late ObjectIconData iconData;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
    descriptionController = TextEditingController(
      text: widget.category.description ?? '',
    );
    iconData = widget.category.iconData;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AlertDialog(
      title: Text(l10n.categoriesEditTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizing.dialogMaxWidth),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                // Name field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.categoriesEditName,
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.categoriesEditNameRequired;
                    }
                    return null;
                  },
                ),
                // Description field
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.categoriesEditDescription,
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 300,
                  maxLines: 3,
                ),
                // Icon editor
                ObjectIconEditor(
                  initialData: iconData,
                  onChanged: (data) {
                    setState(() {
                      iconData = data;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: handleSave, child: Text(l10n.save)),
      ],
    );
  }

  void handleSave() {
    if (formKey.currentState?.validate() ?? false) {
      final updatedCategory = widget.category.copyWith(
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        iconData: iconData,
      );
      Navigator.of(context).pop();
      widget.onSave(updatedCategory);
    }
  }
}
