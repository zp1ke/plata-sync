import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';
import 'package:plata_sync/core/presentation/resources/app_sizing.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A view toggle widget that allows switching between list and grid view modes.
class ViewToggle extends StatelessWidget {
  /// Current selected view mode
  final ViewMode value;

  /// Callback when the view mode changes
  final ValueChanged<ViewMode> onChanged;

  const ViewToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return SegmentedButton<ViewMode>(
      segments: [
        ButtonSegment(
          value: ViewMode.list,
          icon: Icon(AppIcons.viewList, size: AppSizing.iconSm),
          tooltip: l10n.viewList,
        ),
        ButtonSegment(
          value: ViewMode.grid,
          icon: Icon(AppIcons.viewGrid, size: AppSizing.iconSm),
          tooltip: l10n.viewGrid,
        ),
      ],
      selected: {value},
      onSelectionChanged: (Set<ViewMode> newSelection) {
        onChanged(newSelection.first);
      },
    );
  }
}
