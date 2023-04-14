import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_component/shared_component.dart';

class AuthGuard extends RouteGuard {
  Api api = Api();
  BuildContext? context;
  AuthGuard(this.context);
  @override
  String? get redirectTo => '/login/';

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    var newData = path.substring(1).split('/');
    if (newData.isNotEmpty) {
      if (['home', 'profile', 'help'].contains(newData.elementAt(0)) ||
          newData.length > 1) {
        AuthGuardStore.getInstance().setBreadCrumb(newData);
      }
    }

    bool isValidated = await api.userToken(false, context!) != '';

    return isValidated;
  }
}
