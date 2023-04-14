import 'package:flutter/material.dart';

import '../g_text/g_text.dart';
import '../g_text/g_text_variant.dart';

/// Create switch.
class GCheckBox extends StatelessWidget {
  const GCheckBox({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  /// Text that describes the switch.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// Whether this switch is on or off.
  final bool value;

  /// A callback after the user toggles the switch.
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
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
      value: value,
      onChanged: onChanged,
    );
  }
}
