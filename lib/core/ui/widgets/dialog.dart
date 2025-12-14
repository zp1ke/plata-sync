import 'dart:math';

import 'package:flutter/material.dart';
import '../../model/object_icon_data.dart';
import '../resources/app_icons.dart';
import '../resources/app_sizing.dart';
import '../resources/app_spacing.dart';
import 'object_icon.dart';

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
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxHeight =
        contentHeight ?? min(AppSizing.dialogMaxHeight, screenHeight * 0.75);
    final body = Padding(padding: AppSpacing.paddingVerticalXs, child: content);

    return AlertDialog(
      insetPadding: AppSpacing.paddingMd,
      title: Row(
        spacing: AppSpacing.md,
        mainAxisSize: MainAxisSize.min,
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
        height: scrollable ? null : maxHeight,
        child: scrollable
            ? ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(child: body),
              )
            : body,
      ),
      actions: actions,
    );
  }
}
