import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'g_section_title_theme_data.dart';

// final gSectionTitleThemeDataProvider = ScopedProvider(
//   (ref) => GSectionTitleThemeData(),
// );
final gSectionTitleThemeDataProvider = Provider((ref) => GSectionTitleThemeData());


/// Theme for `GSectionTitle`
class GSectionTitleTheme extends StatelessWidget {
  const GSectionTitleTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// Theme data to be overridden.
  final GSectionTitleThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        gSectionTitleThemeDataProvider.overrideWithValue(data),
      ],
      child: child,
    );
  }
}

