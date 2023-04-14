import 'package:flutter/material.dart';

class GGroupedDrawerAction extends StatelessWidget {
  const GGroupedDrawerAction({
    Key? key,
    required this.isSelected,
    required this.actionColor,
    required this.actionSelectedColor,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final bool isSelected;
  final Color? actionColor;
  final Color? actionSelectedColor;
  final void Function() onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        iconTheme: IconThemeData(
          color: isSelected
              ? actionSelectedColor ?? colorScheme.primary
              : actionColor ?? colorScheme.onSurface.withOpacity(.75),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
