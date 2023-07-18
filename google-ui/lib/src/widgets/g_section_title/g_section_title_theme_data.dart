import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'g_section_title_theme.dart';

/// Theme data for `GSectionTitleTheme`
class GSectionTitleThemeData {
  /// An empty space.
  final EdgeInsets? padding;

  /// Set [title] text color.
  final Color? color;

  /// Set [GSectionTitle] background color.
  final Color? backgroundColor;

  GSectionTitleThemeData({
    this.padding = const EdgeInsets.fromLTRB(16, 24, 16, 8),
    this.color,
    this.backgroundColor,
  });

  GSectionTitleThemeData copyWith({
    EdgeInsets? padding,
    Color? color,
    Color? backgroundColor,
  }) {
    return GSectionTitleThemeData(
      padding: padding ?? this.padding,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Return current `GSectionTitleThemeData` of this context.
  static GSectionTitleThemeData of(BuildContext context,WidgetRef ref) {
    return ref.read(gSectionTitleThemeDataProvider);
  }
}
