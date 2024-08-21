import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// class RouteObserverService extends RouteObserver<PageRoute<dynamic>> {}

class RouteChangeObserver extends WidgetsBindingObserver {
  final Function(String) onRouteChange;

  RouteChangeObserver({required this.onRouteChange});

  @override
  Future<bool> didPopRoute() async {
    super.didPopRoute();
    final currentRoute = Modular.to.path;
    onRouteChange(currentRoute); // Access route name
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkCurrentRoute();
    }
  }

  void _checkCurrentRoute() {
    final currentRoute = Modular.to.path;
    onRouteChange(currentRoute); // Access route name
  }
}
