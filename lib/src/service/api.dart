import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/service/storage_service.dart';

import '../components/toast.dart';
import '../environment/system.env.dart';
import '../languages/intl.dart';
import '../models/token.dart';

typedef DynamicFunction = void Function(dynamic);

class Api {
  final Dio http = Dio();
  final BuildContext? context;
  late String lang;

  Api({this.context}) {
    lang = '';
    if(context != null) {
      Toast.init(context);
    }
  }

  Future<String> userToken(bool login) async {
    var jsonToken = await StorageService.getJson('user_token');
    if (jsonToken == null || jsonToken.isEmpty) {
      if (login) {
        return await userLogin();
      } else {
        return '';
      }
    } else {
      Token t = Token.fromJson(jsonToken);
      if (t.expiresAt != null && t.expiresAt!.isAfter(DateTime.now())) {
        return t.accessToken!;
      } else if (login) {
        return await refreshToken(t);
      } else {
        return '';
      }
    }
  }

  Future<String> userLogin() async {
    final navigatorKey = GlobalKey<NavigatorState>();
    print('You should login ${navigatorKey.currentWidget}');
    // var principle = await StorageService.getJson('user');
    // var userName = principle['name'];
    // var userEmail = principle['email'];
    // showDialog<void>(
    //   context: context!,
    //   barrierDismissible: false,
    //   // false = user must tap button, true = tap outside dialog
    //   builder: (BuildContext dialogContext) {
    //     return AlertDialog(
    //       title: Text('Are you Jimmyson'),
    //       actions: <Widget>[
    //         GElevatedButton(
    //           'Login',
    //           onPressed: () {
    //
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
    return '';
  }

  Future<String> refreshToken(Token token) async {
    Options requestOptions =
        Options(contentType: 'application/x-www-form-urlencoded', headers: {
      'Accept': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}'
    });
    Map<String, dynamic>? res = await post('/oauth/token',
        {'grant_type': 'refresh_token', 'refresh_token': token.refreshToken},
        options: requestOptions);
    if (res?['access_token'] != null) {
      Token token = Token.fromJson(res!);
      StorageService.setJson('user_token', token.toJson());
      return token.accessToken!;
    }
    return userLogin();
  }

  Future<String> clientToken() async {
    var jsonToken = await StorageService.getJson("client_token");
    if (jsonToken == null || jsonToken.isEmpty) {
      return await clientLogin();
    } else {
      Token t = Token.fromJson(jsonToken);
      if (t.expiresAt != null && t.expiresAt!.isAfter(DateTime.now())) {
        return t.accessToken!;
      } else {
        return await clientLogin();
      }
    }
  }

  Future<String> clientLogin() async {
    Options requestOptions =
        Options(contentType: 'application/x-www-form-urlencoded', headers: {
      'Accept': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}'
    });
    Map<String, dynamic> res = await request(
        type: 'post',
        url: '/oauth/token',
        options: requestOptions,
        data: {'grant_type': 'client_credentials'});
    if (res['access_token'] != null) {
      Token token = Token.fromJson(res);
      StorageService.setJson('client_token', token.toJson());
      return token.accessToken!;
    }
    return '';
  }

  Future request(
      {required String type,
      required String url,
      dynamic data,
      required Options options}) async {
    try {
      var result = type == 'post'
          ? await http.post(
              serverUrl + url,
              data: data,
              options: options,
            )
          : await http.get(serverUrl + url,
              queryParameters: data, options: options);
      Map<String, dynamic> res = jsonDecode(result.toString());
      if (res['access_token'] != null ||
          res['error_description'] != null ||
          res['principal'] != null) {
        return res;
      }
      if (res['status'] == false) {
        if (res['message'].contains("Invalid access token")) {
          Token token =
              Token.fromJson(await StorageService.getJson('user_token'));
          await refreshToken(token);
          options.headers!['Authorization'] =
              'Bearer ${await userToken(false)}';
          return request(type: type, url: url, data: data, options: options);
        } else if (res['message'].contains('First login')) {

          return res['data'];
        }else if (res['message'].contains('Password Expired')){

          return res['data'];
        }else if(res['message'] == 'OTP Expired'){

          return null;
        }
        Toast.error(res['message']);
      }
      return res['data'];
    } on DioError catch (e) {
      if (e.response != null) {
        var res = e.response!.data as Map<String, dynamic>;
        if (res['error_description'] != null) {
          Toast.error(Intl.trans(res['error_description'], lang));
          return null;
        }
        if (res['status'] == false) {
          if (res['message'].contains("Invalid access token")) {
            await clientLogin();
            options.headers!['Authorization'] = 'Bearer ${await clientToken()}';
            return request(type: type, url: url, data: data, options: options);
          } else {
            Toast.error(res['message']);
          }
        }
        return res['data'];
      }
      return e.message;
    }
  }

  Future post(String url, dynamic data, {Options? options}) async {
    String token = await userToken(false);
    if (token == '') token = await clientToken();
    return request(
        type: 'post',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
  }

  Future clientPost(String url, dynamic data) async {
    return request(
        type: 'post',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await clientToken()}'
        }));
  }

  Future userPost(String url, dynamic data) async {
    return request(
        type: 'post',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await userToken(true)}'
        }));
  }

  Future get(String url, {dynamic data}) async {
    String token = await userToken(false);
    if (token == '') token = await clientToken();
    return request(
        type: 'get',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
  }

  void cacheGet(String url, DynamicFunction callBack, {dynamic data}) async {
    Map<String, dynamic> cache = await StorageService.getJson('cache') ?? {};
    if (cache[url] != null) {
      callBack(cache[url]);
    }
    dynamic storedData = await get(url, data: data);
    cache[url] = storedData;
    StorageService.setJson('cache', cache);
    callBack(storedData);
  }

  void invalidateToken(String _token) async {
    Map<String, dynamic> token =
        await StorageService.getJson("user_token") ?? {};
    if (token['access_token'] == _token) {
      StorageService.setJson('user_token', null);
    } else {
      token = await StorageService.getJson("client_token") ?? {};
      if (token['access_token'] == _token) {
        StorageService.setJson('client_token', null);
      }
    }
  }

}
