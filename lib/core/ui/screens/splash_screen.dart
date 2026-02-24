import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../resources/app_icons.dart';
import '../resources/app_sizing.dart';
import '../resources/app_spacing.dart';

enum SplashStatus { loading, error }

class SplashScreen extends StatelessWidget {
  final SplashStatus status;

  const SplashScreen({super.key, this.status = SplashStatus.loading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppL10n.of(context);
    final isLoading = status == SplashStatus.loading;
    final statusText = isLoading ? l10n.splashLoading : l10n.startupError;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.surface, colorScheme.surfaceContainerLow],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: AppSpacing.paddingXl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcons.appIcon(context, size: AppSizing.iconPreviewSize),
                  AppSpacing.gapLg,
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapLg,
                  if (isLoading)
                    SizedBox(
                      width: AppSizing.iconLg,
                      height: AppSizing.iconLg,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizing.borderWidthMedium,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
