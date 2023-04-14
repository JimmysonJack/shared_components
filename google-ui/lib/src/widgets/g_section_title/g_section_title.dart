import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../g_text/g_text.dart';
import 'g_section_title_theme.dart';

/// Create a section title.
class GSectionTitle extends ConsumerWidget {
  const GSectionTitle(
    this.title, {
    Key? key,
    this.padding,
    this.color,
    this.colorBuilder,
    this.backgroundColor,
    this.backgroundColorBuilder,
  }) : super(key: key);

  /// Text that describes the section.
  final String title;

  /// An empty space.
  /// If null, `EdgeInsets.fromLTRB(16, 24, 16, 8)` is used.
  final EdgeInsets? padding;

  /// Set [title] text color.
  final Color? color;

  /// Set text color using colorBuilder
  final Color? Function(ColorScheme)? colorBuilder;

  /// Set [GSectionTitle] background color.
  final Color? backgroundColor;

  /// Set background color using backgroundColorBuilder
  final Color? Function(ColorScheme)? backgroundColorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final gSectionTitleThemeData = ref.watch(gSectionTitleThemeDataProvider);

    final textColor = color ??
        colorBuilder?.call(Theme.of(context).colorScheme) ??
        gSectionTitleThemeData.color ??
        colorScheme.primary;
    final backgroundColor = this.backgroundColor ??
        backgroundColorBuilder?.call(Theme.of(context).colorScheme) ??
        gSectionTitleThemeData.backgroundColor;

    return Container(
      padding: padding ?? gSectionTitleThemeData.padding,
      color: backgroundColor,
      width: double.infinity,
      child: GText(
        title,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
