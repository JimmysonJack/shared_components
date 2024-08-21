import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/utils/g_ui/g_text.dart';

import '../side_menu/data/resizer_toggle_data.dart';
import '../side_menu/data/side_menu_data.dart';
import '../side_menu/side_menu.dart';
import '../side_menu/side_menu_controller.dart';
import '../side_menu/side_menu_mode.dart';
import 'side_menu_tile_controller.dart';

enum AppBarPosition { top, side }

class SideNavigation extends StatefulWidget {
  const SideNavigation(
      {super.key,
      this.useAppBar = true,
      this.topAppBarDetails,
      required this.body,
      required this.sideMenuTile,
      this.version,
      this.showSideNav = true,
      this.icon,
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
  final bool showSideNav;
  final IconData? icon;

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
  double barHeight = 30;
  String? selectedTitle;
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
    var route = NavigationService.get.fullCurrentRoute.split('/');
    if (!SettingsService.use.isEmptyOrNull(widget.sideMenuTile)) {
      int pageIndex = widget.sideMenuTile.indexWhere(
          (element) => element.url == route.elementAt(route.length - 1));
      setState(() {
        selectedTitle =
            widget.sideMenuTile[pageIndex == -1 ? 0 : pageIndex].title;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mobileWidthSize = SizeConfig.fullScreen.width <= 400;
    return Scaffold(
      appBar: widget.appBarPosition == AppBarPosition.top &&
              widget.useAppBar &&
              widget.topAppBarDetails != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: TopAppBar(
                usePadding: widget.topAppBarDetails?.usePadding,
                onSettings: widget.topAppBarDetails!.onSettings,
                appLogo: widget.topAppBarDetails?.appLogo,
                title: widget.topAppBarDetails!.title,
                userDetails: widget.topAppBarDetails!.userProfileDetails,
                onTap: widget.topAppBarDetails!.onTap,
                menuItems: widget.topAppBarDetails!.menuItems,
                body: widget.body,
              ))
          : widget.showSideNav
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: TopAppBar(
                    usePadding: widget.topAppBarDetails?.usePadding,
                    onSettings: widget.topAppBarDetails!.onSettings,
                    appLogo: widget.topAppBarDetails?.appLogo,
                    title: widget.topAppBarDetails!.title,
                    userDetails: widget.topAppBarDetails!.userProfileDetails,
                    onTap: widget.topAppBarDetails!.onTap,
                    menuItems: widget.topAppBarDetails!.menuItems,
                    body: const SizedBox.shrink(),
                  )),
      body: !widget.showSideNav
          ? widget.body
          : Row(
              children: [
                if (!mobileWidthSize)
                  SideMenu(
                      toggleController: toggleController,
                      backgroundColor: Colors.black12,
                      resizerToggleData: ResizerToggleData(
                          iconColor: Theme.of(context).iconTheme.color!),
                      hasResizer: false,
                      hasResizerToggle: true,
                      mode: SideMenuMode.auto,
                      builder: (data) => sideMenuTiles(
                          sideMenuTile: widget.sideMenuTile,
                          selectedIndex: selectedIndex,
                          icon: widget.icon,
                          version: widget.version,
                          selectedColor: widget.selectedColor,
                          useBorderRadius: widget.useBorderRadius,
                          onTap: (index) {
                            if (widget.sideMenuTile[index].onTap != null) {
                              widget.sideMenuTile[index]
                                  .onTap!(widget.sideMenuTile[index].title);
                            }
                            return selectedIndex = index;
                          })),
                Expanded(
                  child: widget.useAppBar &&
                          widget.topAppBarDetails != null &&
                          widget.appBarPosition == AppBarPosition.side
                      ? TopAppBar(
                          usePadding: widget.topAppBarDetails?.usePadding,
                          onSettings: widget.topAppBarDetails!.onSettings,
                          appLogo: widget.topAppBarDetails?.appLogo,
                          title: mobileWidthSize
                              ? GText(selectedTitle ?? '')
                              : widget.topAppBarDetails!.title,
                          userDetails:
                              widget.topAppBarDetails!.userProfileDetails,
                          onTap: widget.topAppBarDetails!.onTap,
                          menuItems: widget.topAppBarDetails!.menuItems,
                          body: widget.body,
                        )
                      : Center(child: widget.body),
                ),
              ],
            ),
      bottomNavigationBar: mobileWidthSize
          ? widget.sideMenuTile.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: ThemeController.getInstance().darkMode(
                              darkColor: Colors.white38,
                              lightColor: Colors.black45),
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                        )
                      ],
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20))),
                  child: InkWell(
                      onTap: () {
                        bottomNav();
                      },
                      child: const Text('view menu')),
                )
          : const SizedBox.shrink(),
    );
  }

  bottomNav() {
    var route = NavigationService.get.fullCurrentRoute.split('/');
    int pageIndex = widget.sideMenuTile.indexWhere(
        (element) => element.url == route.elementAt(route.length - 1));
    if (pageIndex == -1) {
      Modular.to.navigate(widget.sideMenuTile[0].url);
      selectedIndex = 0;
    } else {
      selectedIndex = pageIndex;
    }
    showBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter stateSetter) {
            return Container(
              // height: 200,
              constraints: const BoxConstraints(
                minHeight: 150,
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeController.getInstance().darkMode(
                          darkColor: Colors.white38,
                          lightColor: Colors.black45),
                      blurRadius: 5,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              width: SizeConfig.fullScreen.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                        widget.sideMenuTile.length,
                        (index) => SizedBox(
                              // height: 50,
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      stateSetter(() {
                                        selectedIndex = index;
                                        barHeight = 50;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 1000),
                                          () {
                                        stateSetter(() {
                                          barHeight = 30;
                                        });
                                      });
                                      if (widget.sideMenuTile[index].onTap !=
                                          null) {
                                        widget.sideMenuTile[index].onTap!(
                                            widget.sideMenuTile[index].title);
                                      }

                                      Modular.to.navigate(
                                          widget.sideMenuTile[index].url);
                                      setState(() {
                                        selectedTitle =
                                            widget.sideMenuTile[index].title;
                                      });
                                    },
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: selectedIndex == index
                                              ? Theme.of(context).primaryColor
                                              : ThemeController.getInstance()
                                                  .darkMode(
                                                      darkColor:
                                                          Theme.of(context)
                                                              .canvasColor,
                                                      lightColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              202,
                                                              226,
                                                              245)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          AnimatedContainer(
                                            height: selectedIndex == index
                                                ? barHeight
                                                : 30,
                                            duration: const Duration(
                                                milliseconds: 1000),
                                            // margin: const EdgeInsets.symmetric(
                                            //     vertical: 15),
                                            width: 5,
                                            color: const Color.fromARGB(
                                                255, 2, 125, 226),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Icon(
                                                widget.sideMenuTile[index].icon,
                                                size: 35,
                                                color: ThemeController
                                                        .getInstance()
                                                    .darkMode(
                                                        darkColor: Colors.white,
                                                        lightColor:
                                                            Colors.black38),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.sideMenuTile[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  )
                                ],
                              ),
                            )),
                  ),
                ),
              ),
            );
          });
        });
  }

  SideMenuData sideMenuTiles(
      {required List<SideMenuTile> sideMenuTile,
      String? badgeContent,
      required int selectedIndex,
      required int Function(int index) onTap,
      bool useBorderRadius = false,
      final String? version,
      final IconData? icon,
      Color? selectedColor}) {
    return SideMenuData(
        // customChild: customChild,
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
                              icon ?? Icons.person,
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
  final VoidCallback onSettings;
  final List<MenuItem> menuItems;
  final Widget? title;
  final Widget? appLogo;
  final bool? usePadding;

  TopAppBarDetails(
      {this.title,
      required this.userProfileDetails,
      required this.menuItems,
      required this.appLogo,
      required this.onSettings,
      this.usePadding,
      required this.onTap});
}
