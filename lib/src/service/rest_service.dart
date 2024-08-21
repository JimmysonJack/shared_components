import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class RestService {
  static final Options _requestOptions =
      Options(contentType: 'application/x-www-form-urlencoded', headers: {
    'Accept': 'application/json',
    'Authorization':
        'Basic ${base64Encode(utf8.encode('${Environment.getInstance().getClientId()}:${Environment.getInstance().getClientSecret()}'))}'
  });
  static final Api _api = Api();
  static postRequest({required BuildContext context}) async {
    Map<String, dynamic> res = await _api.request(context,
        type: 'post',
        url: '/oauth/token',
        options: _requestOptions,
        data: {'grant_type': 'client_credentials'});
    if (res['access_token'] != null) {
      Token token = Token.fromJson(res);
      StorageService.setJson('client_token', token.toJson());
      return token.accessToken!;
    }
  }

  static getRequest({required BuildContext context}) async {
    // Map<String, dynamic> res = await _api.request(context,
    //     type: 'post',
    //     url: '/oauth/token',
    //     options: _requestOptions,
    //     data: {'grant_type': 'client_credentials'});
  }
}
