import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../languages/intlx.dart';

part 'auth_guard_store.g.dart';

class AuthGuardStore extends _AuthGuardStoreBase with _$AuthGuardStore {
  static AuthGuardStore? _instance;

  static AuthGuardStore getInstance() {
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
                content: e == 'home'
                    ? Container()
                    : InkWell(
                        child: Text(Intl.trans(camelToSentence(e), lang)),
                        onTap: () {
                          String url = '';
                          for (var j = 0; j <= i; j++) {
                            if (i == 0) {
                              url += '/${parts[j]}/';
                            } else {
                              url += '/${parts[j]}';
                            }
                          }
                          Modular.to.navigate(url);
                        },
                      )));
      })
      .values
      .toList();

  String camelToSentence(String text) {
    var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
    var finalResult = text;
    if (result != '') {
      finalResult = result[0].toUpperCase() + result.substring(1);
    }
    return finalResult;
  }

  @action
  setBreadCrumb(path) => parts = path;
}
