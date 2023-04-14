import 'package:flutter/material.dart';

import '../g_text/g_text.dart';
import '../g_text/g_text_variant.dart';

/// Create an app bar.
class GAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.centerTitle,
    this.bottom,
    this.elevation,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.leadingWidth,
    this.actions,
    this.backgroundColor,
    this.backgroundColorBuilder,
    this.foregroundColor,
    this.foregroundColorBuilder,
  }) : super(key: key);

  /// Text to display as title.
  final String title;

  /// Text to display as a subtitle, below the title.
  final String? subtitle;

  /// If true align the title to the center.
  final bool? centerTitle;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// Size of the shadow below app bar.
  final double? elevation;

  /// A widget to display before the [GAppBar]'s [title].
  final Widget? leading;

  /// If true allow to imply the leading widget.
  final bool automaticallyImplyLeading;

  /// Defines the width of [leading] widget.
  final double? leadingWidth;

  /// A list of Widgets to display in a row after the [title].
  final List<Widget>? actions;

  /// Set background color.
  final Color? backgroundColor;

  /// Set background color using colorBuilder
  final Color? Function(ColorScheme)? backgroundColorBuilder;

  /// The default color for [Text] and [Icon]s within the app bar.
  final Color? foregroundColor;

  /// Set foreground color using colorBuilder
  final Color? Function(ColorScheme)? foregroundColorBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final _backgroundColor = backgroundColor ??
        backgroundColorBuilder?.call(colorScheme) ??
        theme.appBarTheme.backgroundColor;
    final _foregroundColor = foregroundColor ??
        foregroundColorBuilder?.call(colorScheme) ??
        theme.appBarTheme.titleTextStyle?.color;

    return AppBar(
      title: Column(
        crossAxisAlignment: centerTitle != null && centerTitle!
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          GText(
            title,
            variant: GTextVariant.headline6,
            fontWeight: FontWeight.normal,
            color: _foregroundColor,
          ),
          if (subtitle != null)
            GText(
              subtitle!,
              fontWeight: FontWeight.normal,
              color: _foregroundColor,
            ),
        ],
      ),
      bottom: bottom,
      centerTitle: centerTitle,
      elevation: elevation,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      actions: actions,
      backgroundColor: _backgroundColor,
      iconTheme: IconThemeData(color: _foregroundColor),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
