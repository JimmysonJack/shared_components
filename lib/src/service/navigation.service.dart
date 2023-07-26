import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavigationService {
  static NavigationService? _instance;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static NavigationService get get {
    _instance ??= NavigationService();
    return _instance!;
  }

  BuildContext? get currentContext => navigatorKey.currentContext;

  String get firstCurrentRoute => Modular.to.navigateHistory.first.name;
  String get lastCurrentRoute => Modular.to.navigateHistory.last.name;
  String get fullCurrentRoute => Modular.to.path;
}
