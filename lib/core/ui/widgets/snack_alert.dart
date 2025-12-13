import 'package:flutter/material.dart';
import '../resources/app_icons.dart';
import '../resources/app_sizing.dart';
import '../resources/app_spacing.dart';

/// Variants for the SnackAlert
enum SnackAlertVariant { info, success, error }

/// A consistent snackbar alert component with variants for different message types.
class SnackAlert {
  SnackAlert._();

  /// Shows a snackbar with the specified variant, message, and optional title.
  ///
  /// [context] - The build context
  /// [message] - The message to display
  /// [title] - Optional title for the snackbar
  /// [variant] - The variant (info, success, error), defaults to info
  /// [duration] - How long to show the snackbar, defaults to 4 seconds
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    SnackAlertVariant variant = SnackAlertVariant.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors and icon based on variant
    final Color backgroundColor;
    final Color contentColor;
    final Widget icon;

    switch (variant) {
      case SnackAlertVariant.success:
        backgroundColor = colorScheme.primaryContainer;
        contentColor = colorScheme.onPrimaryContainer;
        icon = AppIcons.checkCircle(
          color: contentColor,
          size: AppSizing.iconMd,
        );
        break;
      case SnackAlertVariant.error:
        backgroundColor = colorScheme.errorContainer;
        contentColor = colorScheme.onErrorContainer;
        icon = AppIcons.errorCircle(
          color: contentColor,
          size: AppSizing.iconMd,
        );
        break;
      case SnackAlertVariant.info:
        backgroundColor = colorScheme.secondaryContainer;
        contentColor = colorScheme.onSecondaryContainer;
        icon = AppIcons.infoCircle(color: contentColor, size: AppSizing.iconMd);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            icon,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: contentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: contentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSm),
        ),
      ),
    );
  }

  /// Shows an info snackbar
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      variant: SnackAlertVariant.info,
      duration: duration,
    );
  }

  /// Shows a success snackbar
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      variant: SnackAlertVariant.success,
      duration: duration,
    );
  }

  /// Shows an error snackbar
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      variant: SnackAlertVariant.error,
      duration: duration,
    );
  }
}
