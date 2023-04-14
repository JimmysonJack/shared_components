import 'package:flutter/material.dart';

import 'g_grouped_drawer_action.dart';

class GGroupedDrawerActionBar extends StatelessWidget {
  const GGroupedDrawerActionBar({
    Key? key,
    required this.actionColor,
    required this.actionSelectedColor,
    required this.isSelected,
    required this.onPressed,
    required this.actions,
    required this.secondaryActions,
  }) : super(key: key);

  final Color? actionColor;
  final Color? actionSelectedColor;
  final bool Function(int index) isSelected;
  final void Function(int index) onPressed;
  final List<Widget> actions;
  final List<Widget>? secondaryActions;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionsChildren = [];

    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      actionsChildren.add(
        GGroupedDrawerAction(
          actionColor: actionColor,
          actionSelectedColor: actionSelectedColor,
          isSelected: isSelected(i),
          onPressed: () => onPressed(i),
          icon: action,
        ),
      );
    }

    return Container(
      width: 80,
      padding: const EdgeInsets.only(bottom: 16),
      child: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(children: actionsChildren),
            ),
            if (secondaryActions != null) ...[
              const Spacer(),
              ...secondaryActions!,
            ]
          ],
        ),
      ),
    );
  }
}
