import 'package:flutter/material.dart';
import 'package:spring/spring.dart';

import 'g_grouped_drawer_action_bar.dart';

/// Create a grouped drawer.
class GGroupedDrawer extends StatefulWidget {
  const GGroupedDrawer({
    Key? key,
    this.actionColor,
    this.actionSelectedColor,
    this.backgroundColor,
    this.initialIndex,
    this.onPageChanged,
    this.isEnd = false,
    required this.actions,
    this.secondaryActions,
    required this.children,
  })  : assert(actions.length == children.length),
        super(key: key);

  /// Set [GGroupedDrawerAction] icon color.
  final Color? actionColor;

  /// Set [GGroupedDrawerAction] on selected icon color.
  final Color? actionSelectedColor;

  /// Set [GGroupedDrawer] background color.
  final Color? backgroundColor;

  /// initial page index.
  final int? initialIndex;

  final void Function(int index)? onPageChanged;

  /// If true, display [actions] after [children].
  final bool isEnd;

  /// A list of Widgets to control [index].
  final List<Widget> actions;

  /// A list of Widgets to display in a column after [actions].
  final List<Widget>? secondaryActions;

  /// A list of Widgets to display menus.
  final List<Widget> children;

  @override
  State<GGroupedDrawer> createState() => _GGroupedDrawerState();
}

class _GGroupedDrawerState extends State<GGroupedDrawer> {
  final scrollController = ScrollController();
  late int pageIndex;

  @override
  void initState() {
    pageIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = widget.backgroundColor ?? colorScheme.surface;

    final List<Widget> drawerChildren = [
      GGroupedDrawerActionBar(
        actionColor: widget.actionColor,
        actionSelectedColor: widget.actionSelectedColor,
        isSelected: (index) => index == pageIndex,
        onPressed: (index) {
          setState(() {
            pageIndex = index;
            scrollController.jumpTo(0);
            if (widget.onPageChanged != null) widget.onPageChanged!(index);
          });
        },
        actions: widget.actions,
        secondaryActions: widget.secondaryActions,
      ),
      const VerticalDivider(width: 0),
      Expanded(
        child: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Spring.scale(
              start: 0.75,
              end: 1,
              curve: standardEasing,
              animDuration: const Duration(milliseconds: 250),
              child: Spring.fadeIn(
                curve: standardEasing,
                animDuration: const Duration(milliseconds: 250),
                child: widget.children[pageIndex],
              ),
            ),
          ),
        ),
      ),
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: backgroundColor,
      ),
      child: SizedBox(
        width: 320,
        child: Drawer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: !widget.isEnd
                ? drawerChildren
                : drawerChildren.reversed.toList(),
          ),
        ),
      ),
    );
  }
}
