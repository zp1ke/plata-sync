import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon_editor.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class CategoryEditDialog extends StatefulWidget {
  final Category? category;
  final void Function(Category updatedCategory) onSave;

  const CategoryEditDialog({this.category, required this.onSave, super.key});

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late ObjectIconData iconData;
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category?.name ?? '');
    descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    iconData =
        widget.category?.iconData ??
        const ObjectIconData(
          iconName: 'shopping_cart',
          backgroundColorHex: 'E3F2FD',
          iconColorHex: '2196F3',
        );

    nameController.addListener(validateForm);
    // Validate initial state
    WidgetsBinding.instance.addPostFrameCallback((_) => validateForm());
  }

  @override
  void dispose() {
    nameController.removeListener(validateForm);
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AlertDialog(
      title: Text(
        widget.category == null
            ? l10n.categoriesCreateTitle
            : l10n.categoriesEditTitle,
      ),
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
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '${l10n.categoriesEditName} *',
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
                    labelText:
                        '${l10n.categoriesEditDescription} (${l10n.optional})',
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
        FilledButton(
          onPressed: isFormValid ? handleSave : null,
          child: Text(l10n.save),
        ),
      ],
    );
  }

  void handleSave() {
    if (formKey.currentState?.validate() ?? false) {
      final category = widget.category != null
          ? widget.category!.copyWith(
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
              iconData: iconData,
            )
          : Category.create(
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
              iconData: iconData,
            );
      Navigator.of(context).pop();
      widget.onSave(category);
    }
  }

  void validateForm() {
    final isValid = nameController.text.trim().isNotEmpty;
    if (isValid != isFormValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }
}
