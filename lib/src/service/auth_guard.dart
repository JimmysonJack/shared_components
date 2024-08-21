import 'dart:async';
import 'package:shared_component/shared_component.dart';

class AuthGuard extends RouteGuard {
  Api api = Api();
  AuthGuard();
  @override
  String? get redirectTo => '/login';

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    var newPath = path.substring(1).split('/');
    if (newPath.isNotEmpty) {
      if (['home', 'profile', 'help'].contains(newPath.elementAt(0)) ||
          newPath.length > 1) {
        AuthGuardStore.getInstance().setBreadCrumb(newPath);
      }
    }

    bool isValidated =
        await api.userToken(false, NavigationService.get.currentContext) != '';

    return isValidated;
  }
}
