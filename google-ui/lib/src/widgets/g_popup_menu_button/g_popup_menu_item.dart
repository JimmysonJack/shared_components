import 'package:flutter/material.dart';

/// Create popup menu item.
class GPopupMenuItem {
  final void Function() onPressed;
  final Widget? icon;
  final String label;

  GPopupMenuItem({
    required this.onPressed,
    this.icon,
    required this.label,
  });
}
