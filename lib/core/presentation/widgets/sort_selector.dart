import 'package:flutter/material.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';

/// A generic sort selector widget that displays a dropdown menu with sort options.
///
/// Type [T] represents the enum type for sort options.
class SortSelector<T extends Enum> extends StatelessWidget {
  /// The currently selected sort option.
  final T value;

  /// Callback when a sort option is selected.
  final ValueChanged<T> onChanged;

  /// Function that returns the display label for a given sort option.
  final String Function(T) labelBuilder;

  /// List of all available sort options.
  final List<T> options;

  const SortSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.sort, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(labelBuilder(value), overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) => options
          .map(
            (option) =>
                PopupMenuItem(value: option, child: Text(labelBuilder(option))),
          )
          .toList(),
    );
  }
}
