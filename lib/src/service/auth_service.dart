import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_component/src/service/storage_service.dart';

import '../components/toast.dart';
import '../environment/system.env.dart';
import '../models/token.dart';
import 'api.dart';
import 'package:mobx/mobx.dart';

part 'auth_service.g.dart';

class AuthServiceStore extends _AuthServiceStoreBase with _$AuthServiceStore{

}
abstract class _AuthServiceStoreBase with Store{

  @observable
  bool loading = false;

  @action
  setLoading(bool value) => loading = value;

  Api? api;
  @action
  getContext(context) {
    api = Api(context);
    Toast.init(context);
    return context;
  }

  @action
  Future<bool> loginUser(
      {required String username, required String password}) async {

      Map<String, String> credentials = {
        'grant_type': 'password',
        'username': username,
        'password': password
      };
      Options requestOptions =
          Options(contentType: 'application/x-www-form-urlencoded', headers: {
        'Accept': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}'
      });
      var res = await api?.request(
          type: 'post',
          url: '/oauth/token',
          data: credentials,
          options: requestOptions);
      if (res != null && res is Map) {
        if (res['access_token'] != null) {
          StorageService.setJson('user_token', res);
          setLoading(false);
          return true;
        } else if (res['error_description'] != null) {
          Toast.error(res['error_description']);
          return false;
        }
        return false;
      } else {
        Toast.error('Error contacting server');
        return false;
      }
  }

  @action
  Future<bool> getUser() async {
    var res = await api?.get('/user');
    if (res != null) {
      if (res is String) {
        StorageService.setString('user_uid', res);
        return false;
      } else if (res is Map) {
        StorageService.setJson('user', res);
        return true;
      }
    }
    return false;
  }

  @action
  Future<bool> changePassword(
      {required String uid,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    var res = await api?.clientPost('/user/changePassword', {
      'uid': uid,
      'currentPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword
    });
    if (res != null) {
      StorageService.setString('user_uid', null);
      return true;
    }
    return false;
  }

  @action
  Future<bool> logoutUser(
      {required String accessToken, required String refreshToken}) async {
    var jsonToken = await StorageService.getJson('user_token');
    if (jsonToken == null || jsonToken.isEmpty) {
      StorageService.setString('user_token', null);
      return true;
    }
    Token t = Token.fromJson(jsonToken);
    var res = await api?.clientPost(
        '/oauth/token/revoke?access_token=${t.accessToken}&refresh_token=${t.refreshToken}',
        {});
    if (res != null) {
      StorageService.setJson('user_token', {});
      StorageService.setJson('user', {});
      return true;
    }
    return false;
  }
}
