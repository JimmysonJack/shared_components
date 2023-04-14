import 'package:flutter/material.dart';

import '../g_text/g_text.dart';
import '../g_text/g_text_variant.dart';

/// Create list tile.
class GListTile extends StatelessWidget {
  const GListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.tileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
  }) : super(key: key);

  /// The primary content of the list tile.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// A widget to display before the title.
  final Widget? leading;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Whether this list tile is intended to display three lines of text.
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  final bool? dense;

  /// The tile's internal padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether this list tile is interactive.
  final bool enabled;

  /// Called when the user taps this list tile.
  final void Function()? onTap;

  /// Called when the user long press this list tile.
  final void Function()? onLongPress;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  /// Defines the background color of ListTile when [selected] is false.
  final Color? tileColor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// The horizontal gap between the titles and the leading/trailing widgets.
  final double? horizontalTitleGap;

  /// The minimum padding on the top and bottom of the title and subtitle widgets.
  final double? minVerticalPadding;

  /// The minimum width allocated for the [ListTile.leading] widget.
  final double? minLeadingWidth;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: GText(
        title,
        variant: GTextVariant.bodyText1,
      ),
      subtitle: subtitle != null
          ? GText(
              subtitle!,
              colorBuilder: (c) => c.onBackground.withOpacity(.75),
            )
          : null,
      leading: leading,
      trailing: trailing,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: contentPadding,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
      mouseCursor: mouseCursor,
      tileColor: tileColor,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
    );
  }
}
