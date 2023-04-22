import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/src/shared/side-navigation/side-menu-tile.dart';

import '../../../shared_component.dart';

class SideMenuTileController extends GetxController {
  final isSelected = false.obs;
  List<SideMenuItemDataTile>? buildTileAndPermissionCheck({
    required List<SideMenuTile> sideMenuTile,
    required int Function(int index) onTap,
    bool useBorderRadius = false,
    Color? selectedColor,
    required int selectedIndex,
  }) {
    if (sideMenuTile.isEmpty) {
      return null;
    }
    // SettingsService.use.permissionCheck(element.permissions)
    final selectedTile = sideMenuTile.elementAt(selectedIndex);
    return sideMenuTile
        .where((element) => true)
        .map((e) => SideMenuItemDataTile(
              badgeStyle: BadgeStyle(
                  padding: const EdgeInsets.all(6),
                  badgeColor: Colors.red.withOpacity(0.9)),
              badgeContent:
                  e.badgeContent == null ? null : Text(e.badgeContent!),
              borderRadius: useBorderRadius
                  ? BorderRadius.circular(20)
                  : BorderRadius.circular(5),
              isSelected: e == selectedTile,
              onTap: () {
                final newIndex = sideMenuTile.indexOf(e);
                onTap(newIndex);
              },
              hoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.27),
              highlightSelectedColor: selectedColor ??
                  Theme.of(Get.context!).primaryColor.withOpacity(0.6),
              tooltip: e.tooltip,
              selectedColor: Colors.white,
              unSelectedColor: ThemeController.getInstance().darkMode(
                  darkColor:
                      const Color.fromARGB(255, 30, 104, 128), // light blue

                  lightColor:
                      Theme.of(Get.context!).textTheme.labelLarge!.color!),
              title: e.title,
              icon: Icon(e.icon),
            ))
        .toList();
  }
}
