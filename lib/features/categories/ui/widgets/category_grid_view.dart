import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/ui/widgets/responsive_grid_view.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

class CategoryGridView extends StatelessWidget {
  final List<Category> categories;
  final void Function(Category category)? onTap;
  final String? selectedCategoryId;

  const CategoryGridView({
    required this.categories,
    this.onTap,
    this.selectedCategoryId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridView(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategoryId == category.id;
        return Card(
          clipBehavior: Clip.hardEdge,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: onTap != null ? () => onTap!(category) : null,
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  ObjectIcon(iconData: category.iconData),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Text(
                          category.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (category.description != null &&
                            category.description!.isNotEmpty)
                          Text(
                            category.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
