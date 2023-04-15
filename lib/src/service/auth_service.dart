// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/service/storage_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../components/toast.dart';
import '../environment/system.env.dart';
import '../models/token.dart';
import 'api_service.dart';
import 'package:mobx/mobx.dart';

import 'notification_service.dart';
part 'auth_service.g.dart';

enum Checking {
  proceed,
  doNotProceed,
  stay,
  idle,
  firstLogin,
  passwordExpired,
  otpExpired
}

class AuthServiceStore extends _AuthServiceStoreBase with _$AuthServiceStore {}

abstract class _AuthServiceStoreBase with Store {
  @observable
  bool loading = false;

  @observable
  String? passwordValue;

  @computed
  bool get passwordHasError => passwordValue == null || passwordValue!.isEmpty;

  @action
  setPass(String value) {
    passwordValue = value;
  }

  @action
  setLoading(bool value) => loading = value;

  Api? api = Api();

  @action
  Future<Checking> loginUser(BuildContext context,
      {required String username,
      required String password,
      bool showLoading = false}) async {
    if (showLoading) setLoading(true);
    Map<String, String> credentials = {
      'grant_type': 'password',
      'username': username,
      'password': password
    };
    Options requestOptions =
        Options(contentType: 'application/x-www-form-urlencoded', headers: {
      'Accept': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${Environment.getInstance().getClientId()}:${Environment.getInstance().getClientSecret()}'))}'
    });
    var res = await api?.request(context,
        type: 'post',
        url: '/oauth/token',
        data: credentials,
        options: requestOptions);
    if (res != null && res is Map && !res.keys.contains('checking')) {
      if (res['access_token'] != null) {
        Token token = Token.fromJson(res as Map<String, dynamic>);
        StorageService.setJson('user_token', token.toJson());
        setLoading(false);
        return Checking.proceed;
      } else if (res['error_description'] != null) {
        NotificationService.snackBarError(
          context: context,
          title: res['error'],
          subTitle: res['error_description'],
        );
        setLoading(false);
        return Checking.doNotProceed;
      }
      setLoading(false);
      return Checking.doNotProceed;
    } else {
      if (res is String) {
        NotificationService.snackBarError(
          context: context,
          title: 'Unable to contact server',
          subTitle: res,
        );
      }
      setLoading(false);
      return Checking.doNotProceed;
    }
  }

  @action
  Future<Checking> getUser(BuildContext context) async {
    var res = await api?.get('/user', context);
    if (res != null) {
      if (res is String) {
        StorageService.setString('user_uid', res);
        setLoading(false);
        return Checking.doNotProceed;
      } else if (res is Map && !res.keys.contains('checking')) {
        StorageService.setJson('user', res);
        setLoading(false);
        if (res['principal']['firstLogin']) {
          return Checking.firstLogin;
        } else if (DateTime.parse(res['principal']['passwordExpiresAt'])
            .isBefore(DateTime.now())) {
          return Checking.passwordExpired;
        }

        return Checking.proceed;
      } else if (res is Map && res['checking'] == Checking.firstLogin) {
        await NotificationService.confirmWarn(
            context: context,
            title: 'First Login Detected',
            content:
                'In order to proceed, you are advised to change your Password first',
            confirmBtnText: 'Ok',
            onConfirmBtnTap: () {
              Navigator.pop(context, true);
            });
        return Checking.firstLogin;
      } else if (res is Map && res['checking'] == Checking.passwordExpired) {
        await NotificationService.confirmWarn(
            context: context,
            title: 'Password Expiration Detected',
            content:
                'In order to proceed, you are advised to change your Password first',
            confirmBtnText: 'Ok',
            onConfirmBtnTap: () {
              Navigator.pop(context, true);
            });
        return Checking.passwordExpired;
      } else if (res is Map && res['checking'] == Checking.otpExpired) {
        await NotificationService.confirmWarn(
            context: context,
            title: 'One Time Password (OTP)',
            content:
                'It seems like OTP is expired, you are advised to contact System Adminstrator',
            confirmBtnText: 'Ok',
            onConfirmBtnTap: () {
              Navigator.pop(context, true);
            });
        return Checking.otpExpired;
      }
    }

    setLoading(false);
    return Checking.stay;
  }

  @action
  Future<Checking> changePassword(BuildContext context,
      {required String uid,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    setLoading(true);
    var res = await api?.clientPost(
        '/user/changePassword',
        {
          'uid': uid,
          'currentPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword
        },
        context);
    if (res != null) {
      StorageService.setString('user_uid', null);
      NotificationService.snackBarSuccess(
          context: context, title: 'Password Changed Successfully');
      setLoading(false);
      return Checking.proceed;
    }
    NotificationService.snackBarError(
        context: context, title: 'Password  Unsuccessfully Changed');
    setLoading(false);
    return Checking.doNotProceed;
  }

  @action
  Future<bool> logoutUser(BuildContext context,
      {required String accessToken, required String refreshToken}) async {
    var jsonToken = await StorageService.getJson('user_token');
    if (jsonToken == null || jsonToken.isEmpty) {
      StorageService.setString('user_token', null);
      return true;
    }
    Token t = Token.fromJson(jsonToken);
    var res = await api?.clientPost(
        '/oauth/token/revoke?access_token=${t.accessToken}&refresh_token=${t.refreshToken}',
        {},
        context);
    if (res != null) {
      StorageService.setJson('user_token', {});
      StorageService.setJson('user', {});
      return true;
    }
    return false;
  }
}
