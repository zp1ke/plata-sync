import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categories;

  const CategoryListView({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpacing.paddingSm,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () {
              // TODO: Navigate to category details
            },
            borderRadius: AppSizing.borderRadiusMd,
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                children: [
                  ObjectIcon(
                    iconName: category.icon,
                    backgroundColorHex: category.backgroundColorHex,
                    iconColorHex: category.iconColorHex,
                  ),
                  AppSpacing.gapHorizontalMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (category.description != null &&
                            category.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            category.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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
