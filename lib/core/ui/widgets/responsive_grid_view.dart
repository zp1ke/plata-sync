import 'package:flutter/material.dart';
import '../resources/app_spacing.dart';

/// A responsive grid view that adjusts column count and aspect ratio based on available width
class ResponsiveGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGridView({
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Calculate crossAxisCount based on available width
        int crossAxisCount;
        double childAspectRatio;

        if (width < 400) {
          // Narrow: single column
          crossAxisCount = 1;
          childAspectRatio = 2.2;
        } else if (width < 800) {
          // Standard: 2 columns
          crossAxisCount = 2;
          childAspectRatio = 1.8;
        } else if (width < 1200) {
          // Wide: 3 columns
          crossAxisCount = 3;
          childAspectRatio = 2.0;
        } else {
          // Very wide: 4 columns
          crossAxisCount = 4;
          childAspectRatio = 1.8;
        }

        return GridView.builder(
          padding: padding ?? AppSpacing.paddingSm,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
