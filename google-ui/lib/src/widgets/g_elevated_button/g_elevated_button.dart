import 'package:flutter/material.dart';

class GElevatedButton extends StatelessWidget {
  const GElevatedButton(
    this.label, {
    Key? key,
    this.icon,
    required this.onPressed,
    this.color,
    this.colorBuilder,
    this.labelColor,
    this.labelColorBuilder,
  }) : super(key: key);

  /// Text that describes the button.
  final String label;

  /// A widget to display before the [label].
  final Widget? icon;

  /// A callback after the user click the button.
  final void Function()? onPressed;

  /// Set button color.
  final Color? color;

  /// Set button color.
  final Color Function(ColorScheme colorScheme)? colorBuilder;

  /// Set button label color.
  final Color? labelColor;

  /// Set button label color.
  final Color Function(ColorScheme colorScheme)? labelColorBuilder;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      primary: color ?? colorBuilder?.call(Theme.of(context).colorScheme),
      onPrimary:
          labelColor ?? labelColorBuilder?.call(Theme.of(context).colorScheme),
    );

    return icon == null
        ? ElevatedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: Text(label),
          )
        : ElevatedButton.icon(
            style: buttonStyle,
            onPressed: onPressed,
            icon: icon!,
            label: Text(label),
          );
  }
}
