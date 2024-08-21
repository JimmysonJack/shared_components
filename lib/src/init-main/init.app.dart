import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

import 'app.module.dart';
import 'app.widget.dart';

// void initApp(
//     {required String appName,
//     required Function loadEnvFile,
//     required List<ParallelRoute> routes}) async {
//   await initHiveForFlutter();
//   await loadEnvFile();
//   var permissions = await StorageService.getUser();
//   Permissions.instance().setAuthorities(List<Map<String, dynamic>>.from(
//       permissions?['principal']?['authorities'] ?? []));
//   var brightness =
//       SchedulerBinding.instance.platformDispatcher.platformBrightness;
//   bool isDarkMode = brightness == Brightness.dark;
//   ThemeController.getInstance().themInitializer(isDarkMode);
//   if (await StorageService.principalUser is Map<String, dynamic>) {
//     StorageService.get.setUser(await StorageService.principalUser);
//   }
//   runApp(ModularApp(
//     module: AppModule(routes),
//     child: AppWidget(appName: appName),
//   ));
// }

void initApp({
  required String appName,
  required Future<void> Function() loadEnvFile,
  required List<ParallelRoute> routes,
  required AppColors appColors,
  CustomTheme? customTheme,
}) async {
  console('Init app is called');
  try {
    // Parallelize initialization tasks using Future.wait
    await Future.wait([
      initHiveForFlutter(),
      loadEnvFile(),
    ]);

    final permissions = await StorageService.getUser();
    final authorities = permissions?['principal']?['authorities'] ?? [];
    Permissions.instance().setAuthorities(List<Map<String, dynamic>>.from(
      authorities,
    ));

    /// Checking platform theme mode
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    ThemeController.getInstance().themInitializer(isDarkMode);

    final principalUser = await StorageService.principalUser;
    if (principalUser is Map<String, dynamic>) {
      StorageService.get.setUser(principalUser);
    }
    console('Running App now');
    runApp(ModularApp(
      module: AppModule(routes),
      child: AppWidget(
        customTheme: customTheme,
        appName: appName,
        appColors: appColors,
      ),
    ));
  } catch (error) {
    // Handle errors gracefully, you can log the error for debugging
    // You might want to show an error screen/dialog to the user
  }
}
