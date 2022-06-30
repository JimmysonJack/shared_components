import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../languages/intl.dart';

part 'auth_guard_store.g.dart';

class AuthGuardStore = _AuthGuardStoreBase with _$AuthGuardStore;
abstract class _AuthGuardStoreBase with Store {

  @observable
  List<String> _parts = Modular.to.path.substring(1).split("/");

  @observable
  String lang = '';

  @computed
  List<BreadCrumbItem> get breadCrumbItems =>_parts
      .asMap()
      .map((i, e) {
    return MapEntry(
        i,
        BreadCrumbItem(
            content: InkWell(
              child: Text(Intl.trans(e, lang)),
              onTap: () {
                String url = '';
                for (var j = 1; j <= i; j++) {
                  url += '/${_parts[j]}';
                }
                Modular.to.navigate(url);
              },
            )));
  }).values.toList();

  @action
  setBreadCrumb(path) => _parts = path;
}