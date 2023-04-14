import 'package:flutter/material.dart';

import '../g_text/g_text.dart';

/// Create a list tile for drawer
class GDrawerListTile extends StatelessWidget {
  const GDrawerListTile({
    Key? key,
    this.leading,
    required this.title,
    this.trailing,
    this.borderRadius = const BorderRadius.horizontal(
      right: Radius.circular(30),
    ),
    this.contentPadding = const EdgeInsets.only(
      left: 16,
      right: 24,
    ),
    this.padding = const EdgeInsets.only(right: 8),
    this.selected = false,
    this.selectedColor,
    this.onTap,
  }) : super(key: key);

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final String title;

  /// A widget to display aftrt the title.
  final Widget? trailing;

  /// The radii for each corner.
  final BorderRadiusGeometry? borderRadius;

  /// The tile's internal padding.
  final EdgeInsetsGeometry? contentPadding;

  /// The amount of space by which to inset the [ListTile].
  final EdgeInsetsGeometry? padding;

  /// Whether list tile is selected.
  final bool selected;

  /// If specified, the color used when a [ListTile] is selected.
  final Color? selectedColor;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedColor = this.selectedColor ?? colorScheme.primary;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ListTileTheme(
        contentPadding: contentPadding,
        selectedColor: selectedColor,
        selectedTileColor: selectedColor.withOpacity(.1),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        dense: true,
        child: ListTile(
          leading: leading,
          title: GText(
            title,
            fontWeight: FontWeight.w500,
            color: selected ? selectedColor : null,
          ),
          trailing: trailing,
          selected: selected,
          onTap: onTap,
        ),
      ),
    );
  }
}
