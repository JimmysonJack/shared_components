import 'package:flutter/material.dart';

import 'g_select_box_item.dart';
import 'g_select_box_list_tile.dart';

/// Create a select box.
class GSelectBox<T> extends StatelessWidget {
  const GSelectBox({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  /// Mark item if [item.value] is equal to [value].
  final T value;

  /// A list [GSelectBoxItem] to display as option to select.
  final List<GSelectBoxItem<T>> items;

  /// A callback after user select an option.
  final void Function(T value) onChanged;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (int i = 0; i < items.length; i++) {
      children.add(GSelectBoxListTile(
        item: items[i],
        isSelected: value == items[i].value,
        onTap: () => onChanged(items[i].value),
      ));

      if (i != items.length - 1) {
        children.add(const Divider(height: 0, indent: 16));
      }
    }

    return Column(children: children);
  }
}
