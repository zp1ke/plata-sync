import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon_editor.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A reusable form widget for creating and editing categories.
/// Can be used in dialogs or inline in detail panes.
class CategoryEditForm extends StatefulWidget {
  final Category? category;
  final void Function(Category category) onSave;
  final VoidCallback? onCancel;
  final bool showActions;

  const CategoryEditForm({
    this.category,
    required this.onSave,
    this.onCancel,
    this.showActions = true,
    super.key,
  });

  @override
  State<CategoryEditForm> createState() => _CategoryEditFormState();
}

class _CategoryEditFormState extends State<CategoryEditForm> {
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

    nameController.addListener(_validateForm);
    // Validate initial state
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
  }

  @override
  void dispose() {
    nameController.removeListener(_validateForm);
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizing.dialogMaxWidth),
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
              // Actions (optional - for inline use)
              if (widget.showActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: AppSpacing.sm,
                  children: [
                    if (widget.onCancel != null)
                      TextButton(
                        onPressed: widget.onCancel,
                        child: Text(l10n.cancel),
                      ),
                    FilledButton(
                      onPressed: isFormValid ? _handleSave : null,
                      child: Text(l10n.save),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
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
      widget.onSave(category);
    }
  }

  void _validateForm() {
    final isValid = nameController.text.trim().isNotEmpty;
    if (isValid != isFormValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }
}
