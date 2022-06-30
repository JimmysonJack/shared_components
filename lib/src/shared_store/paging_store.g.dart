// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paging_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PagingStore on _PagingStoreBase, Store {
  Computed<int>? _$pageSizeComputed;

  @override
  int get pageSize =>
      (_$pageSizeComputed ??= Computed<int>(() => super.pageSize,
              name: '_PagingStoreBase.pageSize'))
          .value;

  late final _$_pageSizeAtom =
      Atom(name: '_PagingStoreBase._pageSize', context: context);

  @override
  int get _pageSize {
    _$_pageSizeAtom.reportRead();
    return super._pageSize;
  }

  @override
  set _pageSize(int value) {
    _$_pageSizeAtom.reportWrite(value, super._pageSize, () {
      super._pageSize = value;
    });
  }

  late final _$_PagingStoreBaseActionController =
      ActionController(name: '_PagingStoreBase', context: context);

  @override
  dynamic setSize(dynamic value) {
    final _$actionInfo = _$_PagingStoreBaseActionController.startAction(
        name: '_PagingStoreBase.setSize');
    try {
      return super.setSize(value);
    } finally {
      _$_PagingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageSize: ${pageSize}
    ''';
  }
}
