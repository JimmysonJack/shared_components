import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';
import 'package:shared_component/src/shared/top-app-bar/theme_changer_popup_menu_item.dart';
import 'package:shared_component/src/shared/top-app-bar/user_profile_popup_menu_item.dart';

import 'custom_popup_menu_item.dart';
import 'menu_item.dart';
import 'user_profile_item.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar(
      {super.key,
      this.title = '',
      required this.body,
      required this.menuItems,
      required this.userDetails,
      required this.onSettings,
      required this.onTap});
  final List<MenuItem> menuItems;
  final UserProfileItem userDetails;
  final String title;
  final Widget body;
  final Function() onSettings;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        actions: [
          PopupMenuButton<String>(
            padding: const EdgeInsets.only(right: 20),
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => [
              UserProfilePopupMenuItem(userProfileItem: userDetails),
              ..._popupMenuItems(menuItems),
              ThemeChangerPopuoMenuItem(
                onSettings: onSettings,
              )
            ],
            onSelected: onTap,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
        elevation: 1,
        title: GText(title),
        // notificationPredicate: (value){
        //   value.
        // },
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Center(
          child: body,
        ),
      ),
    );
  }

  List<PopupMenuItem<String>> _popupMenuItems(List<MenuItem> menuItems) {
    if (menuItems.isEmpty) {
      return [];
    }
    var popList = menuItems
        .map((e) => CustomPopupMenuItem<String>(
              menuItem: e,
            ))
        .toList();
    return popList;
  }
}
