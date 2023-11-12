import 'package:flutter/material.dart';

import 'menu_item.dart';

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final MenuItem menuItem;

  CustomPopupMenuItem({super.key, required this.menuItem})
      : super(
            value: menuItem.value,
            child: ListTile(
              title: Text(menuItem.title),
              trailing: Icon(menuItem.icon),
            ));
}
