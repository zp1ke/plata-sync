import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/object_icon.dart';
import '../../domain/entities/category.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categories;
  final void Function(Category category)? onTap;
  final String? selectedCategoryId;

  const CategoryListView({
    required this.categories,
    this.onTap,
    this.selectedCategoryId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpacing.paddingSm,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategoryId == category.id;
        return Card(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (category.description != null &&
                            category.description!.isNotEmpty)
                          Text(
                            category.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
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
