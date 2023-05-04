import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

import '../top-app-bar/menu-item.dart';
import '../top-app-bar/top-app-bar.dart';
import '../top-app-bar/user-profile-item.dart';
import 'side-menu-tile-controller.dart';
import 'side-menu-tile.dart';

enum AppBarPosition { top, side }

class SideNavigation extends StatefulWidget {
  const SideNavigation(
      {super.key,
      this.useAppBar = true,
      this.topAppBarDetails,
      required this.body,
      required this.sideMenuTile,
      this.version,
      this.appBarPosition = AppBarPosition.side,
      this.selectedColor,
      this.useBorderRadius = false});
  final String? version;
  final Color? selectedColor;
  final AppBarPosition appBarPosition;
  final bool useBorderRadius;
  final bool useAppBar;
  final Widget body;
  final TopAppBarDetails? topAppBarDetails;
  final List<SideMenuTile> sideMenuTile;

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -0;
  double currentSize = 0;
  ToggleController toggleController = ToggleController(ToggleState.opened);
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
        // reverseDuration: const Duration(milliseconds: 500),
        vsync: this,
        duration: const Duration(milliseconds: 500));
    _animation = CurveTween(curve: Curves.easeInToLinear)
        .animate(_controller)
        .drive(Tween<double>(begin: 0.0, end: 1.2));
    _controller.forward();

    toggleController.addListener(() {
      if (toggleController.value == ToggleState.opened) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarPosition == AppBarPosition.top &&
              widget.useAppBar &&
              widget.topAppBarDetails != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: TopAppBar(
                onSettings: () {},
                title: widget.topAppBarDetails!.title ?? '',
                userDetails: widget.topAppBarDetails!.userProfileDetails,
                onTap: widget.topAppBarDetails!.onTap,
                menuItems: widget.topAppBarDetails!.menuItems,
                body: widget.body,
              ))
          : null,
      body: Row(
        children: [
          SideMenu(
              toggleController: toggleController,
              backgroundColor: Colors.black12,
              hasResizer: false,
              hasResizerToggle: true,
              mode: SideMenuMode.auto,
              builder: (data) => sideMenuTiles(
                  sideMenuTile: widget.sideMenuTile,
                  selectedIndex: selectedIndex,
                  version: widget.version,
                  selectedColor: widget.selectedColor,
                  useBorderRadius: widget.useBorderRadius,
                  onTap: (index) => selectedIndex = index)),
          Expanded(
            child: widget.useAppBar &&
                    widget.topAppBarDetails != null &&
                    widget.appBarPosition == AppBarPosition.side
                ? TopAppBar(
                    onSettings: () {},
                    title: widget.topAppBarDetails!.title ?? '',
                    userDetails: widget.topAppBarDetails!.userProfileDetails,
                    onTap: widget.topAppBarDetails!.onTap,
                    menuItems: widget.topAppBarDetails!.menuItems,
                    body: widget.body,
                  )
                : Center(child: widget.body),
          ),
        ],
      ),
    );
  }

  SideMenuData sideMenuTiles(
      {required List<SideMenuTile> sideMenuTile,
      String? badgeContent,
      required int selectedIndex,
      required int Function(int index) onTap,
      bool useBorderRadius = false,
      final String? version,
      Color? selectedColor}) {
    return SideMenuData(
        header: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInToLinear,
              height: toggleController.value == ToggleState.opened ? 170 : 55,
              child: Center(
                  child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: FadeTransition(
                            opacity: _animation,
                            child: Icon(
                              Icons.person,
                              color: ThemeController.getInstance().darkMode(
                                  darkColor: Colors.white.withOpacity(0.3),
                                  lightColor: Colors.black26),
                              size: 100,
                            ),
                          ),
                        );
                      })),
            )
          ],
        ),
        items: SideMenuTileController().buildTileAndPermissionCheck(
            sideMenuTile: sideMenuTile,
            selectedIndex: selectedIndex,
            onTap: (index) {
              setState(() => onTap(index));
              return index;
            },
            selectedColor: selectedColor,
            useBorderRadius: useBorderRadius),
        footer: FadeTransition(
          opacity: _controller,
          child: Container(
              color: Colors.black12,
              height: toggleController.value == ToggleState.opened ? 50 : 0,
              child: Center(child: GText('Version $version'))),
        ));
  }
}

class TopAppBarDetails {
  final UserProfileItem userProfileDetails;
  final Function(String) onTap;
  final List<MenuItem> menuItems;
  final String? title;
  TopAppBarDetails(
      {this.title,
      required this.userProfileDetails,
      required this.menuItems,
      required this.onTap});
}
