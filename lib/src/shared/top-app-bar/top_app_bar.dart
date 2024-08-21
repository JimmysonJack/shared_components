import 'package:flutter/material.dart';
import 'package:shared_component/src/shared/top-app-bar/theme_changer_popup_menu_item.dart';
import 'package:shared_component/src/shared/top-app-bar/user_profile_popup_menu_item.dart';
import 'custom_popup_menu_item.dart';
import 'menu_item.dart';
import 'user_profile_item.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar(
      {super.key,
      required this.title,
      required this.body,
      required this.appLogo,
      required this.menuItems,
      required this.userDetails,
      this.usePadding = true,
      required this.onSettings,
      required this.onTap});
  final List<MenuItem> menuItems;
  final UserProfileItem userDetails;
  final Widget? title;
  final Widget body;
  final bool? usePadding;
  final Widget? appLogo;
  final VoidCallback onSettings;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            // padding: const EdgeInsets.only(right: 20),
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
        title: Row(
          children: [
            appLogo ?? const SizedBox(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              // width: 5,
              // height: 50,
              // color: const Color.fromARGB(255, 67, 66, 66),
              child: const Text('|', style: TextStyle(fontFamily: 'Geoplace')),
            ),
            title ?? const SizedBox(),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all((usePadding ?? true) ? 16 : 0),
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
