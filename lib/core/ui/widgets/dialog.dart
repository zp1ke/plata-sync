import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.iconData,
    required this.content,
    this.actions,
    this.scrollable = true,
    this.contentHeight,
  });

  final ObjectIconData? iconData;
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool scrollable;
  final double? contentHeight;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      insetPadding: AppSpacing.paddingMd,
      title: Row(
        spacing: AppSpacing.md,
        children: [
          if (iconData != null)
            ObjectIcon(iconData: iconData!, size: AppSizing.avatarSm),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          IconButton(
            icon: AppIcons.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: AppSizing.dialogMaxWidth,
        height:
            contentHeight ?? min(AppSizing.dialogMaxHeight, screenHeight * 0.7),
        child: scrollable ? SingleChildScrollView(child: content) : content,
      ),
      actions: actions,
    );
  }
}
