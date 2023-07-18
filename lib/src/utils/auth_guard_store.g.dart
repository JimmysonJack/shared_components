// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_guard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthGuardStore on _AuthGuardStoreBase, Store {
  Computed<List<BreadCrumbItem>>? _$breadCrumbItemsComputed;

  @override
  List<BreadCrumbItem> get breadCrumbItems => (_$breadCrumbItemsComputed ??=
          Computed<List<BreadCrumbItem>>(() => super.breadCrumbItems,
              name: '_AuthGuardStoreBase.breadCrumbItems'))
      .value;

  late final _$partsAtom =
      Atom(name: '_AuthGuardStoreBase.parts', context: context);

  @override
  List<String> get parts {
    _$partsAtom.reportRead();
    return super.parts;
  }

  @override
  set parts(List<String> value) {
    _$partsAtom.reportWrite(value, super.parts, () {
      super.parts = value;
    });
  }

  late final _$langAtom =
      Atom(name: '_AuthGuardStoreBase.lang', context: context);

  @override
  String get lang {
    _$langAtom.reportRead();
    return super.lang;
  }

  @override
  set lang(String value) {
    _$langAtom.reportWrite(value, super.lang, () {
      super.lang = value;
    });
  }

  late final _$_AuthGuardStoreBaseActionController =
      ActionController(name: '_AuthGuardStoreBase', context: context);

  @override
  dynamic setBreadCrumb(dynamic path) {
    final _$actionInfo = _$_AuthGuardStoreBaseActionController.startAction(
        name: '_AuthGuardStoreBase.setBreadCrumb');
    try {
      return super.setBreadCrumb(path);
    } finally {
      _$_AuthGuardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
parts: ${parts},
lang: ${lang},
breadCrumbItems: ${breadCrumbItems}
    ''';
  }
}
