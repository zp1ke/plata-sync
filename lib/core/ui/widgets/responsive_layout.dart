import 'package:flutter/material.dart';

import '../resources/app_sizing.dart';

/// Device type based on screen width
enum DeviceType {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == DeviceType.mobile;
  bool get isTablet => this == DeviceType.tablet;
  bool get isDesktop => this == DeviceType.desktop;
  bool get isTabletOrLarger =>
      this == DeviceType.tablet || this == DeviceType.desktop;
}

/// Extension to get device type from BuildContext
extension ResponsiveContext on BuildContext {
  /// Get the current device type based on screen width
  DeviceType get deviceType {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppSizing.breakpointDesktop) {
      return DeviceType.desktop;
    } else if (width >= AppSizing.breakpointMobile) {
      return DeviceType.tablet;
    }
    return DeviceType.mobile;
  }

  /// Check if current device is mobile
  bool get isMobile => deviceType.isMobile;

  /// Check if current device is tablet or larger
  bool get isTabletOrLarger => deviceType.isTabletOrLarger;
}

/// A responsive layout widget that adapts based on screen size
class ResponsiveLayout extends StatelessWidget {
  /// Builder for mobile layout
  final Widget Function(BuildContext context) mobile;

  /// Builder for tablet and desktop layout
  final Widget Function(BuildContext context)? tabletOrLarger;

  const ResponsiveLayout({
    required this.mobile,
    this.tabletOrLarger,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isTabletOrLarger && tabletOrLarger != null) {
      return tabletOrLarger!(context);
    }
    return mobile(context);
  }
}

/// A master-detail layout for tablet+ devices
class MasterDetailLayout extends StatelessWidget {
  /// The master pane (typically a list)
  final Widget master;

  /// The detail pane (typically item details or form)
  final Widget? detail;

  /// Placeholder shown when no detail is selected
  final Widget? detailPlaceholder;

  /// Ratio of master pane width (0.0 to 1.0)
  final double masterWidthRatio;

  const MasterDetailLayout({
    required this.master,
    this.detail,
    this.detailPlaceholder,
    this.masterWidthRatio = 0.4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxMasterWidth = screenWidth * 0.6;
    final minMasterWidth = AppSizing.masterPaneMinWidth;
    final desiredMasterWidth = screenWidth * masterWidthRatio;

    final masterWidth = desiredMasterWidth.clamp(
      minMasterWidth,
      maxMasterWidth.clamp(minMasterWidth, double.infinity),
    );

    return Row(
      children: [
        // Master pane
        SizedBox(width: masterWidth, child: master),
        // Divider
        const VerticalDivider(),
        // Detail pane
        Expanded(child: detail ?? detailPlaceholder ?? const SizedBox.shrink()),
      ],
    );
  }
}
