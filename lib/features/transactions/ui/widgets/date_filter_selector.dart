import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/features/transactions/model/enums/date_filter.dart';

class DateFilterSelector extends StatelessWidget {
  final DateFilter value;
  final ValueChanged<DateFilter>? onChanged;
  final String Function(DateFilter) labelBuilder;

  const DateFilterSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DateFilter>(
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
          spacing: AppSpacing.sm,
          children: [
            AppIcons.calendar,
            Flexible(
              child: Text(
                labelBuilder(value),
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppIcons.arrowDropDownXs,
          ],
        ),
      ),
      itemBuilder: (context) {
        return DateFilter.values.map((filter) {
          return PopupMenuItem<DateFilter>(
            value: filter,
            child: Row(
              children: [
                if (filter == value) ...[
                  AppIcons.checkSm,
                  AppSpacing.gapHorizontalSm,
                ] else
                  const SizedBox(width: AppSizing.iconSm + AppSpacing.sm),
                Text(labelBuilder(filter)),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
