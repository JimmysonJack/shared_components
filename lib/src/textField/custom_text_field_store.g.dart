// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_text_field_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomTextStore on _CustomTextStoreBase, Store {
  Computed<String>? _$fieldValueComputed;

  @override
  String get fieldValue =>
      (_$fieldValueComputed ??= Computed<String>(() => super.fieldValue,
              name: '_CustomTextStoreBase.fieldValue'))
          .value;

  late final _$_fieldValueAtom =
      Atom(name: '_CustomTextStoreBase._fieldValue', context: context);

  @override
  String? get _fieldValue {
    _$_fieldValueAtom.reportRead();
    return super._fieldValue;
  }

  @override
  set _fieldValue(String? value) {
    _$_fieldValueAtom.reportWrite(value, super._fieldValue, () {
      super._fieldValue = value;
    });
  }

  @override
  String toString() {
    return '''
fieldValue: ${fieldValue}
    ''';
  }
}
