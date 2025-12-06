import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';

/// A generic sort selector widget that displays a dropdown menu with sort options.
///
/// Type [T] represents the enum type for sort options.
class SortSelector<T extends Enum> extends StatelessWidget {
  /// The currently selected sort option.
  final T value;

  /// Callback when a sort option is selected.
  final ValueChanged<T>? onChanged;

  /// Function that returns the display label for a given sort option.
  final String Function(T) labelBuilder;

  /// Function that returns the icon widget for a given sort option.
  final Widget Function(T) sortIconBuilder;

  /// List of all available sort options.
  final List<T> options;

  const SortSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    required this.sortIconBuilder,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: onChanged != null,
      initialValue: value,
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: AppSizing.borderRadiusSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            sortIconBuilder(value),
            AppSpacing.gapHorizontalSm,
            Expanded(
              child: Text(labelBuilder(value), overflow: TextOverflow.ellipsis),
            ),
            AppIcons.arrowDropDownXs,
          ],
        ),
      ),
      itemBuilder: (context) => options
          .map(
            (option) => CheckedPopupMenuItem<T>(
              value: option,
              checked: option == value,
              child: Text(labelBuilder(option)),
            ),
          )
          .toList(),
    );
  }
}
