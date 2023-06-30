import 'package:flutter/material.dart';

import '../../g_text_selection_controls.dart';
import '../g_text/g_text.dart';
import '../g_text/g_text_variant.dart';

/// Create app bar with search bar.
class GSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GSearchAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.controller,
    this.centerTitle,
    this.bottom,
    this.elevation,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.leadingWidth,
    this.actions,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.onActionPressed,
    this.open,
    this.backgroundColor,
    this.backgroundColorBuilder,
    this.foregroundColor,
    this.foregroundColorBuilder,
    this.cursorColor,
    this.cursorColorBuilder,
  }) : super(key: key);

  /// Text to display as title.
  final String title;

  /// Text to display as a subtitle, below the title.
  final String? subtitle;

  /// Controls the text being edited.
  final TextEditingController? controller;

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

  /// Text that suggests what sort of input the field accepts.
  final String hintText;

  /// Set keyboard type.
  final TextInputType? keyboardType;

  /// A callback after this field value changed.
  final void Function(String)? onChanged;

  /// A callback after this field submitted.
  final void Function(String)? onFieldSubmitted;

  /// A callback after the user press the action button.
  final void Function()? onActionPressed;

  /// Whether the search bar open or not.
  final bool? open;

  /// Set background color.
  final Color? backgroundColor;

  /// Set background color using colorBuilder
  final Color? Function(ColorScheme)? backgroundColorBuilder;

  /// The default color for [Text] and [Icon]s within the app bar.
  final Color? foregroundColor;

  /// Set foreground color using colorBuilder
  final Color? Function(ColorScheme)? foregroundColorBuilder;

  /// The default color for [cursorColor], [selectionHandleColor] and [selectionColor].
  /// Note [selectionHandleColor] only changed on first build.
  final Color? cursorColor;

  /// Set cursor color using colorBuilder
  final Color? Function(ColorScheme)? cursorColorBuilder;

  @override
  State<GSearchAppBar> createState() => _GSearchAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

class _GSearchAppBarState extends State<GSearchAppBar> {
  late final TextEditingController textController;
  bool isOpen = false;

  @override
  void initState() {
    textController = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final _backgroundColor = widget.backgroundColor ??
        widget.backgroundColorBuilder?.call(colorScheme) ??
        theme.appBarTheme.backgroundColor;
    final _foregroundColor = widget.foregroundColor ??
        widget.foregroundColorBuilder?.call(colorScheme) ??
        theme.appBarTheme.titleTextStyle?.color;
    final _cursorColor = widget.cursorColor ??
        widget.cursorColorBuilder?.call(colorScheme) ??
        theme.textSelectionTheme.cursorColor;

    return AppBar(
      title: (widget.open ?? isOpen)
          ? Theme(
              data: theme.copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: _cursorColor,
                  selectionHandleColor: _cursorColor,
                  selectionColor: _cursorColor?.withOpacity(.40),
                ),
              ),
              child: TextFormField(
                controller: textController,
                autofocus: true,
                keyboardType: widget.keyboardType,
                textInputAction: TextInputAction.search,
                selectionControls: _cursorColor != null
                    ? GTextSelectionControls(_cursorColor)
                    : null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: _foregroundColor?.withOpacity(.5),
                    decorationColor: _foregroundColor?.withOpacity(.5),
                  ),
                ),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _foregroundColor,
                  decorationColor: _foregroundColor,
                ),
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onFieldSubmitted,
              ),
            )
          : Column(
              crossAxisAlignment:
                  widget.centerTitle != null && widget.centerTitle!
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                GText(
                  widget.title,
                  variant: GTextVariant.headline6,
                  fontWeight: FontWeight.normal,
                  color: _foregroundColor,
                ),
                if (widget.subtitle != null)
                  GText(
                    widget.subtitle!,
                    fontWeight: FontWeight.normal,
                    color: _foregroundColor,
                  ),
              ],
            ),
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      bottom: widget.bottom,
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leadingWidth: widget.leadingWidth,
      backgroundColor: _backgroundColor,
      iconTheme: IconThemeData(color: _foregroundColor),
      actions: [
        IconButton(
          icon: Icon((widget.open ?? isOpen) ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              if (widget.open == null) {
                if (!isOpen) {
                  isOpen = true;
                  return;
                }

                if (textController.value.text.isNotEmpty) {
                  textController.clear();
                  if (widget.onChanged != null) widget.onChanged!("");

                  return;
                }

                isOpen = false;
              }

              widget.onActionPressed?.call();
            });
          },
        ),
      ],
    );
  }
}
