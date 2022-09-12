// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pop-up-model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PopupModel on _PopupModelBase, Store {
  Computed<bool>? _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors,
              name: '_PopupModelBase.hasErrors'))
          .value;

  late final _$buildSizeAtom =
      Atom(name: '_PopupModelBase.buildSize', context: context);

  @override
  double get buildSize {
    _$buildSizeAtom.reportRead();
    return super.buildSize;
  }

  @override
  set buildSize(double value) {
    _$buildSizeAtom.reportWrite(value, super.buildSize, () {
      super.buildSize = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_PopupModelBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$_errorsAtom =
      Atom(name: '_PopupModelBase._errors', context: context);

  @override
  bool get _errors {
    _$_errorsAtom.reportRead();
    return super._errors;
  }

  @override
  set _errors(bool value) {
    _$_errorsAtom.reportWrite(value, super._errors, () {
      super._errors = value;
    });
  }

  @override
  String toString() {
    return '''
buildSize: ${buildSize},
loading: ${loading},
hasErrors: ${hasErrors}
    ''';
  }
}
