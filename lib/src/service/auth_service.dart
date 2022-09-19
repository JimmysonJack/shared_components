import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_component/src/service/storage_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../components/toast.dart';
import '../environment/system.env.dart';
import '../models/token.dart';
import 'api.dart';
import 'package:mobx/mobx.dart';

part 'auth_service.g.dart';

enum Checking{proceed,doNotProceed,stay, idle}

class AuthServiceStore extends _AuthServiceStoreBase with _$AuthServiceStore{
  static AuthServiceStore? _instance;
  static AuthServiceStore getInstance(){
    _instance ??= AuthServiceStore();
    return _instance!;
  }

}
abstract class _AuthServiceStoreBase with Store{

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

  Api? api;
  BuildContext? cxt;
  @action
  getContext(BuildContext context) {
    cxt = context;
    api = Api(context:context);
    Toast.init(context);
    return context;
  }

  @action
  Future<bool> loginUser(
      {required String username, required String password, bool showLoading = false}) async {
    if(showLoading) setLoading(true);
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
          Token token = Token.fromJson(res as Map<String,dynamic>);
          StorageService.setJson('user_token', token.toJson());
          return true;
        } else if (res['error_description'] != null) {
          Toast.error(res['error'],subTitle: res['error_description']);
          setLoading(false);
          return false;
        }
        setLoading(false);
        return false;
      } else {
        if(res is String){
          Toast.error('Error contacting server');
        }
        setLoading(false);
        return false;
      }
  }

  @action
  Future<Checking> getUser() async {
    var res = await api?.get('/user');
    if (res != null) {
      if (res is String) {
        StorageService.setString('user_uid', res);
        setLoading(false);
        return Checking.doNotProceed;
      } else if (res is Map) {
        StorageService.setJson('user', res);
        setLoading(false);
        return Checking.proceed;
      }
    }
    otpExpired(cxt);
    setLoading(false);
    return Checking.stay;
  }

  @action
  Future<bool> changePassword(
      {required String uid,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    setLoading(true);
    var res = await api?.clientPost('/user/changePassword', {
      'uid': uid,
      'currentPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword
    });
    if (res != null) {
      StorageService.setString('user_uid', null);
      Toast.info('Password Changed Successfully');
      setLoading(false);
      return true;
    }
    Toast.info('Password  Unsuccessfully Changed');
    setLoading(false);
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
  otpExpired(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text('OTP Expired!',style: Theme.of(context).textTheme.titleMedium,),
            content: Text('contact System Administrator',style: Theme.of(context).textTheme.labelMedium,),
            actions: [
              TextButton(
                  onPressed: (){Modular.to.pop();},
                  child: const Text('Okay'))
            ],
          );
        });
  }
}
