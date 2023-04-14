import 'package:flutter/material.dart';

import 'g_popup_menu_item.dart';

/// Create popup menu button.
class GPopupMenuButton extends StatelessWidget {
  const GPopupMenuButton({Key? key, required this.children}) : super(key: key);

  /// A list of [GPopupMenuItem] to display as [GPopupMenuButton] children.
  final List<GPopupMenuItem> children;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void Function()>(
      itemBuilder: (context) => children
          .map(
            (e) => PopupMenuItem(
              value: e.onPressed,
              child: e.icon != null
                  ? Row(
                      children: [
                        e.icon!,
                        const SizedBox(width: 16),
                        Text(e.label),
                      ],
                    )
                  : Text(e.label),
            ),
          )
          .toList(),
      onSelected: (value) => value(),
    );
  }
}
