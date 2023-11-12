import 'package:flutter/material.dart';

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
    var route = NavigationService.get.fullCurrentRoute.split('/');
    int pageIndex = sideMenuTile.indexWhere(
        (element) => element.url == route.elementAt(route.length - 1));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // This callback will be executed after the widget is fully built and laid out
      if (callOnce) {
        onTap(pageIndex == -1 ? 0 : pageIndex);
        callOnce = false;
        if (pageIndex == -1) Modular.to.navigate(sideMenuTile[0].url);
      }
    });

    if (sideMenuTile.isEmpty) {
      return null;
    }

    final selectedTile = sideMenuTile.elementAt(selectedIndex);
    return sideMenuTile
        .where((element) =>
            SettingsService.use.permissionCheck(element.permissions))
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

                Modular.to.navigate(e.url);
              },
              hoverColor: Theme.of(NavigationService.get.currentContext!)
                  .primaryColor
                  .withOpacity(0.27),
              highlightSelectedColor: selectedColor ??
                  Theme.of(NavigationService.get.currentContext!)
                      .primaryColor
                      .withOpacity(0.6),
              tooltip: e.tooltip,
              selectedColor: Colors.white,
              unSelectedColor: ThemeController.getInstance().darkMode(
                  darkColor:
                      const Color.fromARGB(255, 30, 104, 128), // light blue

                  lightColor: Theme.of(NavigationService.get.currentContext!)
                      .textTheme
                      .labelLarge!
                      .color!),
              title: e.title,
              icon: Icon(e.icon),
            ))
        .toList();
  }
}
