import 'dart:async';

import 'package:flutter/cupertino.dart';
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

   var newData = path.substring(1).split('/');

   if(newData.isNotEmpty){

    if(['home','profile','help'].contains(newData.elementAt(0)) || newData.length > 1){
     AuthGuardStore.getInstance().setBreadCrumb(newData);
     print(newData);
    }
   }
    return true;
  }
  
}