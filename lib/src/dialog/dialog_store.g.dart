// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DialogStore on _DialogStoreBase, Store {
  late final _$buttonEnabledAtom =
      Atom(name: '_DialogStoreBase.buttonEnabled', context: context);

  @override
  bool get buttonEnabled {
    _$buttonEnabledAtom.reportRead();
    return super.buttonEnabled;
  }

  @override
  set buttonEnabled(bool value) {
    _$buttonEnabledAtom.reportWrite(value, super.buttonEnabled, () {
      super.buttonEnabled = value;
    });
  }

  late final _$_DialogStoreBaseActionController =
      ActionController(name: '_DialogStoreBase', context: context);

  @override
  bool validatingInputs(List<dynamic> inputs) {
    final _$actionInfo = _$_DialogStoreBaseActionController.startAction(
        name: '_DialogStoreBase.validatingInputs');
    try {
      return super.validatingInputs(inputs);
    } finally {
      _$_DialogStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
buttonEnabled: ${buttonEnabled}
    ''';
  }
}
