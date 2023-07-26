import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class RouteService {
  static ModuleRoute moduleRoute(
          {required String routeName,
          required Module module,
          List<RouteGuard> guards = const [],
          TransitionType transition = TransitionType.scale}) =>
      ModuleRoute(routeName,
          module: module, transition: transition, guards: guards);

  static ChildRoute childRoute(
          {required String routeName,
          required Widget child,
          List<ParallelRoute<dynamic>> children = const [],
          List<RouteGuard> guards = const [],
          TransitionType transition = TransitionType.fadeIn}) =>
      ChildRoute(routeName,
          child: (context, args) => child,
          children: children,
          transition: transition,
          guards: guards);
}
