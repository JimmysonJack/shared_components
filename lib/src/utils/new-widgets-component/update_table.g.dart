// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_table.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UpdateTable on _UpdateTableBase, Store {
  late final _$updateTableAtom =
      Atom(name: '_UpdateTableBase.updateTable', context: context);

  @override
  bool get updateTable {
    _$updateTableAtom.reportRead();
    return super.updateTable;
  }

  @override
  set updateTable(bool value) {
    _$updateTableAtom.reportWrite(value, super.updateTable, () {
      super.updateTable = value;
    });
  }

  late final _$tableListDataAtom =
      Atom(name: '_UpdateTableBase.tableListData', context: context);

  @override
  List<Map<String, dynamic>> get tableListData {
    _$tableListDataAtom.reportRead();
    return super.tableListData;
  }

  @override
  set tableListData(List<Map<String, dynamic>> value) {
    _$tableListDataAtom.reportWrite(value, super.tableListData, () {
      super.tableListData = value;
    });
  }

  late final _$modalIsOpenedAtom =
      Atom(name: '_UpdateTableBase.modalIsOpened', context: context);

  @override
  bool get modalIsOpened {
    _$modalIsOpenedAtom.reportRead();
    return super.modalIsOpened;
  }

  @override
  set modalIsOpened(bool value) {
    _$modalIsOpenedAtom.reportWrite(value, super.modalIsOpened, () {
      super.modalIsOpened = value;
    });
  }

  late final _$_UpdateTableBaseActionController =
      ActionController(name: '_UpdateTableBase', context: context);

  @override
  dynamic setModalIsOpened(bool value) {
    final _$actionInfo = _$_UpdateTableBaseActionController.startAction(
        name: '_UpdateTableBase.setModalIsOpened');
    try {
      return super.setModalIsOpened(value);
    } finally {
      _$_UpdateTableBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUpdateTable(bool value) {
    final _$actionInfo = _$_UpdateTableBaseActionController.startAction(
        name: '_UpdateTableBase.setUpdateTable');
    try {
      return super.setUpdateTable(value);
    } finally {
      _$_UpdateTableBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
updateTable: ${updateTable},
tableListData: ${tableListData},
modalIsOpened: ${modalIsOpened}
    ''';
  }
}
