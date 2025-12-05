import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A customizable select widget that displays a button and opens a searchable dialog.
/// Useful for selecting from a list of options with optional search functionality.
class SelectField<T> extends StatelessWidget {
  final T? value;
  final List<T> options;
  final String label;
  final String? hint;
  final String? searchHint;
  final String Function(T) itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final bool Function(T, String)? searchFilter;
  final ValueChanged<T> onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const SelectField({
    required this.value,
    required this.options,
    required this.label,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.hint,
    this.searchHint,
    this.itemBuilder,
    this.searchFilter,
    this.validator,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: enabled
                  ? () => _showSelectionDialog(context, field)
                  : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  suffixIcon: AppIcons.arrowDropDownXs,
                  errorText: field.errorText,
                  enabled: enabled,
                ),
                child: value != null
                    ? Text(
                        itemLabelBuilder(value as T),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSelectionDialog(BuildContext context, FormFieldState<T> field) {
    final l10n = AppL10n.of(context);
    showDialog<T>(
      context: context,
      builder: (dialogContext) => _SelectionDialog<T>(
        title: label,
        options: options,
        currentValue: value,
        searchHint: searchHint ?? l10n.selectFieldSearchHint,
        itemLabelBuilder: itemLabelBuilder,
        itemBuilder: itemBuilder,
        searchFilter: searchFilter,
      ),
    ).then((selectedValue) {
      if (selectedValue != null) {
        field.didChange(selectedValue);
        onChanged(selectedValue);
      }
    });
  }
}

class _SelectionDialog<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final T? currentValue;
  final String searchHint;
  final String Function(T) itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final bool Function(T, String)? searchFilter;

  const _SelectionDialog({
    required this.title,
    required this.options,
    required this.currentValue,
    required this.searchHint,
    required this.itemLabelBuilder,
    this.itemBuilder,
    this.searchFilter,
  });

  @override
  State<_SelectionDialog<T>> createState() => _SelectionDialogState<T>();
}

class _SelectionDialogState<T> extends State<_SelectionDialog<T>> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<T> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;

    return widget.options.where((option) {
      if (widget.searchFilter != null) {
        return widget.searchFilter!(option, _searchQuery);
      }
      // Default search: case-insensitive label match
      final label = widget.itemLabelBuilder(option);
      return label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = _filteredOptions;

    return AlertDialog(
      title: Text(widget.title),
      insetPadding: AppSpacing.paddingMd,
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      content: SizedBox(
        width: AppSizing.dialogMaxWidth,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search field
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: widget.searchHint,
                border: const OutlineInputBorder(),
                prefix: Padding(
                  padding: EdgeInsets.only(right: AppSpacing.xs),
                  child: AppIcons.searchXs,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: AppIcons.clear,
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            AppSpacing.gapVerticalMd,
            // Options list
            Expanded(
              child: filteredOptions.isEmpty
                  ? Center(
                      child: Text(
                        AppL10n.of(context).selectFieldNoResults,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredOptions.length,
                      itemBuilder: (context, index) {
                        final option = filteredOptions[index];
                        final isSelected = option == widget.currentValue;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                          title: widget.itemBuilder != null
                              ? widget.itemBuilder!(option)
                              : Text(widget.itemLabelBuilder(option)),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          onTap: () {
                            Navigator.of(context).pop(option);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppL10n.of(context).selectFieldCancel),
        ),
      ],
    );
  }
}
