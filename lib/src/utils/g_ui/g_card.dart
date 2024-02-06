import 'package:flutter/material.dart';

/// Creates a material design card.
class GCard extends StatelessWidget {
  const GCard({
    Key? key,
    this.elevation,
    this.clipBehavior,
    this.color,
    this.shadowColor,
    this.borderRadius,
    this.onPressed,
    this.onLongPress,
    this.padding,
    required this.child,
  }) : super(key: key);

  /// controls the size of the shadow below the card.
  final double? elevation;

  /// The content will be clipped (or not) according to this option.
  final Clip? clipBehavior;

  /// The card's background color.
  final Color? color;

  /// The color of [elevation].
  final Color? shadowColor;

  /// The radii for each corner.
  final BorderRadiusGeometry? borderRadius;

  /// A callback after the user click the button.
  final void Function()? onPressed;

  /// A callback after the user long press the button.
  final void Function()? onLongPress;

  /// An empty space.
  final EdgeInsetsGeometry? padding;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      color: color,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPress,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
