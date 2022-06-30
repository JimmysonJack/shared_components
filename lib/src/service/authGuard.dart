import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_component/src/utils/auth_guard_store.dart';

import 'authService.dart';

class AuthGuard extends RouteGuard{
 final AuthService? authService = AuthService();
 @override
  String? get redirectTo => '/login/';

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
   //TODO Implement return to where i was after being kicked out with login management

   if(path.substring(1).split('/').toString().length != 2){
    AuthGuardStore().setBreadCrumb(path.substring(1).split('/'));
   }
   // print(route.name);
   // print(Modular.to.navigateHistory.map((e) => e.name).toList());
    return true;
  }
  
}