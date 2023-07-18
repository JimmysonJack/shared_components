import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

import 'app.module.dart';
import 'app.widget.dart';

void initApp(
    {required String appName,
    required Function loadEnvFile,
    required List<ParallelRoute> routes}) async {
  await initHiveForFlutter();
  await loadEnvFile();
  var permissions = await StorageService.getUser();
  Permissions.instance().setAuthorities(List<Map<String, dynamic>>.from(
      permissions?['principal']?['authorities'] ?? []));
  ThemeController.getInstance().themInitializer(true);
  if (await StorageService.principalUser is Map<String, dynamic>) {
    StorageService.get.setUser(await StorageService.principalUser);
  }
  runApp(ModularApp(
    module: AppModule(routes),
    child: AppWidget(appName: appName),
  ));
}
