import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  AppModule(this.appRoutes);
  List<ModularRoute> appRoutes;
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => appRoutes;
}
