import 'dart:async';
import 'package:shared_component/shared_component.dart';

import 'navigation.service.dart';

class AuthGuard extends RouteGuard {
  Api api = Api();
  AuthGuard();
  @override
  String? get redirectTo => '/login';

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    var newData = path.substring(1).split('/');
    if (newData.isNotEmpty) {
      if (['home', 'profile', 'help'].contains(newData.elementAt(0)) ||
          newData.length > 1) {
        AuthGuardStore.getInstance().setBreadCrumb(newData);
      }
    }

    bool isValidated =
        await api.userToken(false, NavigationService.get.currentContext) != '';

    return isValidated;
  }
}
