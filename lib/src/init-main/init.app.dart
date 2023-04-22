import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_component/src/themes/theme.dart';

import 'app.module.dart';
import 'app.widget.dart';

void initApp(
    {required String appName,
    required Function loadEnvFile,
    required List<ModularRoute> routes}) async {
  await loadEnvFile();
  ThemeController.getInstance().themInitializer(true);
  runApp(ModularApp(
    module: AppModule(routes),
    child: AppWidget(appName: appName),
  ));
}
