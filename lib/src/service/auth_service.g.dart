// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthServiceStore on _AuthServiceStoreBase, Store {
  late final _$loginUserAsyncAction =
      AsyncAction('_AuthServiceStoreBase.loginUser', context: context);

  @override
  Future<bool> loginUser({required String username, required String password}) {
    return _$loginUserAsyncAction
        .run(() => super.loginUser(username: username, password: password));
  }

  late final _$getUserAsyncAction =
      AsyncAction('_AuthServiceStoreBase.getUser', context: context);

  @override
  Future<bool> getUser() {
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
  dynamic getContext(dynamic context) {
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

    ''';
  }
}
