import 'package:flutter/material.dart';

class GOutlinedButton extends StatelessWidget {
  const GOutlinedButton(
    this.label, {
    Key? key,
    this.icon,
    required this.onPressed,
    this.color,
    this.colorBuilder,
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

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OutlinedButton.styleFrom(
      primary: color ?? colorBuilder?.call(Theme.of(context).colorScheme),
    );

    return icon == null
        ? OutlinedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: Text(label),
          )
        : OutlinedButton.icon(
            style: buttonStyle,
            onPressed: onPressed,
            icon: icon!,
            label: Text(label),
          );
  }
}
