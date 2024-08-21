import 'dart:async';
import 'package:shared_component/shared_component.dart';

class UrlGuard extends RouteGuard {
  UrlGuard(this.onUrlChange);
  final Function(String) onUrlChange;

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    onUrlChange(path);
    return true;
  }
}
