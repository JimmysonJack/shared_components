// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text-inputs.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TextInput on _TextInputBase, Store {
  late final _$updateFieldsAtom =
      Atom(name: '_TextInputBase.updateFields', context: context);

  @override
  List<Map<String, dynamic>>? get updateFields {
    _$updateFieldsAtom.reportRead();
    return super.updateFields;
  }

  @override
  set updateFields(List<Map<String, dynamic>>? value) {
    _$updateFieldsAtom.reportWrite(value, super.updateFields, () {
      super.updateFields = value;
    });
  }

  late final _$itemsAtom = Atom(name: '_TextInputBase.items', context: context);

  @override
  List<Map<String, dynamic>> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(List<Map<String, dynamic>> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$_showPasswordAtom =
      Atom(name: '_TextInputBase._showPassword', context: context);

  @override
  bool get _showPassword {
    _$_showPasswordAtom.reportRead();
    return super._showPassword;
  }

  @override
  set _showPassword(bool value) {
    _$_showPasswordAtom.reportWrite(value, super._showPassword, () {
      super._showPassword = value;
    });
  }

  late final _$updateStateAtom =
      Atom(name: '_TextInputBase.updateState', context: context);

  @override
  bool get updateState {
    _$updateStateAtom.reportRead();
    return super.updateState;
  }

  @override
  set updateState(bool value) {
    _$updateStateAtom.reportWrite(value, super.updateState, () {
      super.updateState = value;
    });
  }

  late final _$_checkBoxStateAtom =
      Atom(name: '_TextInputBase._checkBoxState', context: context);

  @override
  bool get _checkBoxState {
    _$_checkBoxStateAtom.reportRead();
    return super._checkBoxState;
  }

  @override
  set _checkBoxState(bool value) {
    _$_checkBoxStateAtom.reportWrite(value, super._checkBoxState, () {
      super._checkBoxState = value;
    });
  }

  late final _$_switchStateAtom =
      Atom(name: '_TextInputBase._switchState', context: context);

  @override
  bool get _switchState {
    _$_switchStateAtom.reportRead();
    return super._switchState;
  }

  @override
  set _switchState(bool value) {
    _$_switchStateAtom.reportWrite(value, super._switchState, () {
      super._switchState = value;
    });
  }

  late final _$hasErrorsAtom =
      Atom(name: '_TextInputBase.hasErrors', context: context);

  @override
  bool get hasErrors {
    _$hasErrorsAtom.reportRead();
    return super.hasErrors;
  }

  @override
  set hasErrors(bool value) {
    _$hasErrorsAtom.reportWrite(value, super.hasErrors, () {
      super.hasErrors = value;
    });
  }

  late final _$_TextInputBaseActionController =
      ActionController(name: '_TextInputBase', context: context);

  @override
  dynamic setUpdateFields(List<Map<String, dynamic>>? value) {
    final _$actionInfo = _$_TextInputBaseActionController.startAction(
        name: '_TextInputBase.setUpdateFields');
    try {
      return super.setUpdateFields(value);
    } finally {
      _$_TextInputBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCheckBoxState(bool? value) {
    final _$actionInfo = _$_TextInputBaseActionController.startAction(
        name: '_TextInputBase.setCheckBoxState');
    try {
      return super.setCheckBoxState(value);
    } finally {
      _$_TextInputBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSwitchState(bool? value) {
    final _$actionInfo = _$_TextInputBaseActionController.startAction(
        name: '_TextInputBase.setSwitchState');
    try {
      return super.setSwitchState(value);
    } finally {
      _$_TextInputBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
updateFields: ${updateFields},
items: ${items},
updateState: ${updateState},
hasErrors: ${hasErrors}
    ''';
  }
}
