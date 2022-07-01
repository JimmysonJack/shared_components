import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../languages/intl.dart';

part 'auth_guard_store.g.dart';

class AuthGuardStore extends _AuthGuardStoreBase with _$AuthGuardStore{
  static AuthGuardStore? _instance;

  static AuthGuardStore getInstance(){
    _instance ??= AuthGuardStore();
    return _instance!;
  }
}
abstract class _AuthGuardStoreBase with Store {



  @observable
  List<String> parts = Modular.to.path.substring(1).split("/");

  @observable
  String lang = '';

  @computed
  List<BreadCrumbItem> get breadCrumbItems => parts
      .asMap()
      .map((i, e) {
    return MapEntry(
        i,
        BreadCrumbItem(
            content: InkWell(
              child: Text(Intl.trans(e, lang)),
              onTap: () {
                String url = '';
                for (var j = 0; j <= i; j++) {
                  url += '/${parts[j]}';
                }
                Modular.to.navigate(url);
              },
            )));
  }).values.toList();

  @action
  setBreadCrumb(path) => parts = path;
}