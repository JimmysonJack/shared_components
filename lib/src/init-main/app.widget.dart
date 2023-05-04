import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:layout/layout.dart';

import '../service/api_service.dart';
import '../themes/theme.dart';

class AppWidget extends StatelessWidget {
  final String appName;
  AppWidget({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetMaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        home: Obx(() {
          ThemeController.getInstance().isDarkTheme.value;
          return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: appName,
              routeInformationParser: Modular.routeInformationParser,
              routerDelegate: Modular.routerDelegate,
              theme: ThemeController.getInstance().customTheme());
        }),
      ),
    );
  }
}
