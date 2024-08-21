import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class AppWidget extends StatelessWidget {
  final String appName;
  final AppColors appColors;
  final CustomTheme? customTheme;
  const AppWidget(
      {super.key,
      required this.appName,
      required this.appColors,
      this.customTheme});

  // final RouteObserverService routeObserver = RouteObserverService();

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: GetMaterialApp.router(
      // navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: appName,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      builder: (context, child) {
        return Obx(() {
          ThemeController.getInstance().isDarkTheme.value;
          return Theme(
            data: ThemeController.getInstance()
                .themeChanger(appColors, customTheme),
            child: Navigator(
              key: NavigationService.get.navigatorKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => child!, settings: settings),
            ),
          );
        });
      },
    ));
  }
}
