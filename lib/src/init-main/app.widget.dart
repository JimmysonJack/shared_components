import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

class AppWidget extends StatelessWidget {
  final String appName;
  const AppWidget({super.key, required this.appName});

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
            data: ThemeController.getInstance().customTheme(),
            child: Navigator(
              key: NavigationService.navigatorKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => child!, settings: settings),
            ),
          );
        });
      },
      // builder: (context, router) {
      //   return CustomMaterialApp(
      //       debugShowCheckedModeBanner: false,
      //       navigatorKey: NavigationService.navigatorKey,
      //       theme: ThemeController.getInstance().customTheme(),
      //       home: Obx(() {
      //         ThemeController.getInstance().isDarkTheme.value;
      //         return router!;
      //       }));
      // },
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

// MaterialApp(
//       debugShowCheckedModeBanner: false,
//       navigatorKey: NavigationService.navigatorKey,
//       home: CustomMaterialApp.router(
//         navigatorKey: NavigationService.navigatorKey,
//         debugShowCheckedModeBanner: false,
//         title: appName,
//         routeInformationParser: Modular.routeInformationParser,
//         routerDelegate: Modular.routerDelegate,
//         theme: ThemeController.getInstance().customTheme(),
//       ),
//     )
