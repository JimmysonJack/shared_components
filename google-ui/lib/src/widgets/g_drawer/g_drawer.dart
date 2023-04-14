import 'package:flutter/material.dart';

/// Create a drawer
class GDrawer extends StatelessWidget {
  const GDrawer({
    Key? key,
    this.backgroundColor,
    this.enableSafeArea = true,
    required this.child,
  }) : super(key: key);

  /// Set [GDrawer] background color.
  final Color? backgroundColor;

  /// If true, wrap the child widget with [SafeArea].
  final bool enableSafeArea;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: backgroundColor ?? colorScheme.surface,
      ),
      child: Drawer(
        child: enableSafeArea
            ? SafeArea(child: SingleChildScrollView(child: child))
            : child,
      ),
    );
  }
}
