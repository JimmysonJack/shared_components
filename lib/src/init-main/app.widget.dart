import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:layout/layout.dart';
import 'package:shared_component/shared_component.dart';

import '../service/api_service.dart';
import '../themes/theme.dart';

class AppWidget extends StatelessWidget {
  final String appName;
  const AppWidget({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: MaterialApp.router(
      // navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: appName,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      // theme: ThemeController.getInstance().customTheme(),
      builder: (context, router) {
        console('in Init.....');
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            theme: ThemeController.getInstance().customTheme(),
            home: Obx(() {
              ThemeController.getInstance().isDarkTheme.value;
              return router!;
            }));
      },
      // home: Obx(() {
      //   // Ensure that you're updating the value of isDarkTheme
      //   // and returning a widget from the builder function
      //   ThemeController.getInstance().isDarkTheme.value;
      //   return MaterialApp.router(
      //     debugShowCheckedModeBanner: false,
      //     title: appName,
      //     routeInformationParser: Modular.routeInformationParser,
      //     routerDelegate: Modular.routerDelegate,
      //     theme: ThemeController.getInstance().customTheme(),
      //   );
      // }),
    ));
  }
}
