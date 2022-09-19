// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthServiceStore on _AuthServiceStoreBase, Store {
  Computed<bool>? _$passwordHasErrorComputed;

  @override
  bool get passwordHasError => (_$passwordHasErrorComputed ??= Computed<bool>(
          () => super.passwordHasError,
          name: '_AuthServiceStoreBase.passwordHasError'))
      .value;

  late final _$loadingAtom =
      Atom(name: '_AuthServiceStoreBase.loading', context: context);

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

  late final _$passwordValueAtom =
      Atom(name: '_AuthServiceStoreBase.passwordValue', context: context);

  @override
  String? get passwordValue {
    _$passwordValueAtom.reportRead();
    return super.passwordValue;
  }

  @override
  set passwordValue(String? value) {
    _$passwordValueAtom.reportWrite(value, super.passwordValue, () {
      super.passwordValue = value;
    });
  }

  late final _$loginUserAsyncAction =
      AsyncAction('_AuthServiceStoreBase.loginUser', context: context);

  @override
  Future<bool> loginUser(
      {required String username,
      required String password,
      bool showLoading = false}) {
    return _$loginUserAsyncAction.run(() => super.loginUser(
        username: username, password: password, showLoading: showLoading));
  }

  late final _$getUserAsyncAction =
      AsyncAction('_AuthServiceStoreBase.getUser', context: context);

  @override
  Future<Checking> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  late final _$changePasswordAsyncAction =
      AsyncAction('_AuthServiceStoreBase.changePassword', context: context);

  @override
  Future<bool> changePassword(
      {required String uid,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) {
    return _$changePasswordAsyncAction.run(() => super.changePassword(
        uid: uid,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword));
  }

  late final _$logoutUserAsyncAction =
      AsyncAction('_AuthServiceStoreBase.logoutUser', context: context);

  @override
  Future<bool> logoutUser(
      {required String accessToken, required String refreshToken}) {
    return _$logoutUserAsyncAction.run(() =>
        super.logoutUser(accessToken: accessToken, refreshToken: refreshToken));
  }

  late final _$_AuthServiceStoreBaseActionController =
      ActionController(name: '_AuthServiceStoreBase', context: context);

  @override
  dynamic setPass(String value) {
    final _$actionInfo = _$_AuthServiceStoreBaseActionController.startAction(
        name: '_AuthServiceStoreBase.setPass');
    try {
      return super.setPass(value);
    } finally {
      _$_AuthServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLoading(bool value) {
    final _$actionInfo = _$_AuthServiceStoreBaseActionController.startAction(
        name: '_AuthServiceStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_AuthServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getContext(BuildContext context) {
    final _$actionInfo = _$_AuthServiceStoreBaseActionController.startAction(
        name: '_AuthServiceStoreBase.getContext');
    try {
      return super.getContext(context);
    } finally {
      _$_AuthServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
passwordValue: ${passwordValue},
passwordHasError: ${passwordHasError}
    ''';
  }
}
