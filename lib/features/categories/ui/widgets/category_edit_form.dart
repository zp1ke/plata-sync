import 'package:flutter/material.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/input_decoration.dart';
import '../../../../core/ui/widgets/object_icon_editor.dart';
import '../../domain/entities/category.dart';
import '../../model/enums/category_transaction_type.dart';
import '../../../../l10n/app_localizations.dart';

/// A reusable form widget for creating and editing categories.
/// Can be used in dialogs or inline in detail panes.
class CategoryEditForm extends StatefulWidget {
  final Category? category;
  final void Function(Category category) onSave;
  final VoidCallback? onCancel;
  final bool showActions;
  final ValueChanged<bool>? onFormValidChanged;

  const CategoryEditForm({
    this.category,
    required this.onSave,
    this.onCancel,
    this.showActions = true,
    this.onFormValidChanged,
    super.key,
  });

  @override
  State<CategoryEditForm> createState() => CategoryEditFormState();
}

class CategoryEditFormState extends State<CategoryEditForm> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late ObjectIconData iconData;
  late CategoryTransactionType? transactionType;
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
    transactionType = widget.category?.transactionType;

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
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Name field
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecorationWithPrefixIcon(
                    labelText: '${l10n.categoriesEditName} *',
                    prefixIcon: AppIcons.categoriesOutlinedXs,
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
                  decoration: inputDecorationWithPrefixIcon(
                    labelText:
                        '${l10n.categoriesEditDescription} (${l10n.optional})',
                    prefixIcon: AppIcons.descriptionXs,
                  ),
                  maxLength: 200,
                  maxLines: 2,
                ),
                // Icon editor
                ObjectIconEditor(
                  initialData: iconData,
                  iconLabel: l10n.categoriesEditIcon,
                  iconRequiredMessage: l10n.categoriesEditIconRequired,
                  backgroundColorLabel: l10n.categoriesEditBackgroundColor,
                  iconColorLabel: l10n.categoriesEditIconColor,
                  onChanged: (data) {
                    setState(() {
                      iconData = data;
                    });
                  },
                ),
                // Transaction Type selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      '${l10n.categoriesEditTransactionType} (${l10n.optional})',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      l10n.categoriesEditTransactionTypeHelper,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.gapVerticalXs,
                    SegmentedButton<CategoryTransactionType?>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: null,
                          label: Text(l10n.categoryTransactionTypeAny),
                        ),
                        ButtonSegment(
                          value: CategoryTransactionType.income,
                          label: Text(l10n.categoryTransactionTypeIncome),
                        ),
                        ButtonSegment(
                          value: CategoryTransactionType.expense,
                          label: Text(l10n.categoryTransactionTypeExpense),
                        ),
                      ],
                      selected: {transactionType},
                      onSelectionChanged:
                          (Set<CategoryTransactionType?> newSelection) {
                            setState(() {
                              transactionType = newSelection.first;
                            });
                          },
                    ),
                  ],
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
                        onPressed: isFormValid ? handleSave : null,
                        child: Text(l10n.save),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
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
              transactionType: transactionType,
            )
          : Category.create(
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
              iconData: iconData,
              transactionType: transactionType,
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
      widget.onFormValidChanged?.call(isValid);
    }
  }
}
