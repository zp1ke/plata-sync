import 'package:flutter/material.dart';

/// A ListView that constrains its content width while keeping the scrollbar
/// at full width. Useful for creating centered content with max-width constraints
/// on larger screens while maintaining a properly positioned scrollbar.
class ConstrainedListView extends StatelessWidget {
  final double maxWidth;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  const ConstrainedListView({
    required this.maxWidth,
    required this.children,
    this.padding,
    this.controller,
    this.physics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: physics,
      padding: padding ?? EdgeInsets.zero,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
