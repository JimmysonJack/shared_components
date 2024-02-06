import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class AppWidget extends StatelessWidget {
  final String appName;
  final AppColors appColors;
  const AppWidget({super.key, required this.appName, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      builder: (context, child) {
        return Obx(() {
          ThemeController.getInstance().isDarkTheme.value;
          return Theme(
            data: ThemeController.getInstance().themeChanger(appColors),
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
