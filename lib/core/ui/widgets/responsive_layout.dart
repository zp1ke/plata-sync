import 'package:flutter/material.dart';

/// Breakpoints for responsive layouts
class Breakpoints {
  const Breakpoints._();

  /// Mobile devices (phones in portrait)
  static const double mobile = 600.0;

  /// Tablet devices and larger
  static const double tablet = 840.0;

  /// Desktop and large screens
  static const double desktop = 1200.0;
}

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
    final width = MediaQuery.of(this).size.width;
    if (width >= Breakpoints.desktop) {
      return DeviceType.desktop;
    } else if (width >= Breakpoints.mobile) {
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
    return Row(
      children: [
        // Master pane
        Expanded(flex: (masterWidthRatio * 10).round(), child: master),
        // Divider
        const VerticalDivider(width: 1),
        // Detail pane
        Expanded(
          flex: ((1 - masterWidthRatio) * 10).round(),
          child: detail ?? detailPlaceholder ?? const SizedBox.shrink(),
        ),
      ],
    );
  }
}
