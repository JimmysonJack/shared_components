import 'package:flutter/material.dart';

/// Change scroll glow color.
class GScrollColor extends StatelessWidget {
  const GScrollColor({
    Key? key,
    this.color,
    this.colorBuilder,
    this.axisDirection = AxisDirection.down,
    required this.child,
  }) : super(key: key);

  const GScrollColor.horizontal({
    Key? key,
    this.color,
    this.colorBuilder,
    required this.child,
  })  : axisDirection = AxisDirection.right,
        super(key: key);

  const GScrollColor.vertical({
    Key? key,
    this.color,
    this.colorBuilder,
    required this.child,
  })  : axisDirection = AxisDirection.down,
        super(key: key);

  /// Set scroll glow color.
  final Color? color;

  /// Set scroll glow color. using colorBuilder
  final Color? Function(ColorScheme)? colorBuilder;

  /// A scroll direction along either the horizontal or vertical [Axis].
  final AxisDirection axisDirection;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scrollColor = color ?? colorBuilder?.call(colorScheme);

    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: axisDirection,
        color: scrollColor ?? colorScheme.primary,
        child: child,
      ),
    );
  }
}
