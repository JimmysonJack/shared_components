// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
// import 'package:shared_component/shared_component.dart';
// import 'package:shared_component/shared_component.dart';
import 'package:get/get.dart';

enum Checking {
  proceed,
  doNotProceed,
  stay,
  idle,
  firstLogin,
  passwordExpired,
  otpExpired
}

// class AuthServiceStore extends _AuthServiceStoreBase with _$AuthServiceStore {}

class AuthServiceController extends GetxController {
  Api api = Api();
  final http = Dio();
  final password = TextEditingController();
  final loading = false.obs;
  final isButtonEnabled = false.obs;

  @override
  void dispose() {
    super.dispose();
    password.dispose();
  }

  void verifyPassword(value) {
    isButtonEnabled.value = password.text.isNotEmpty;
  }

  Future<Checking> loginUser(BuildContext context,
      {required String username,
      required String password,
      String? url,
      bool showLoading = false}) async {
    console('............................................$url');
    Map<String, String> credentials = {
      'grant_type': 'password',
      'username': username,
      'password': password
    };
    // 'Basic ${base64Encode(utf8.encode('${Environment.getInstance().getClientId()}:${Environment.getInstance().getClientSecret()}'))}'

    Options requestOptions =
        Options(contentType: 'application/x-www-form-urlencoded', headers: {
      'Accept': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${Environment.getInstance().getClientId()}:${Environment.getInstance().getClientSecret()}'))}'
    });
    var res = await api.request(context,
        type: 'post',
        url: url ??
            '${portChecking(Environment.getInstance().getServerUrlPort())}/oauth/token',
        data: credentials,
        options: requestOptions);
    if (res != null && res is Map && !res.keys.contains('checking')) {
      if (res['access_token'] != null) {
        Token token = Token.fromJson(res as Map<String, dynamic>);
        StorageService.setJson('user_token', token.toJson());
        return Checking.proceed;
      } else if (res['error_description'] != null) {
        NotificationService.snackBarError(
          context: context,
          title: res['error'],
          subTitle: res['error_description'],
        );
        return Checking.doNotProceed;
      }
      return Checking.doNotProceed;
    } else {
      if (res is String) {
        NotificationService.snackBarError(
          context: context,
          title: 'Unable to contact server',
          subTitle: res,
        );
      }
      return Checking.doNotProceed;
    }
  }

  Future<Checking> getUser(BuildContext context, String? url) async {
    console('calling user......................................xx');
    url = url != null ? url.replaceAll('oauth/token', 'user') : '/user';
    console('$url matokeo......');
    var res = await api.get(url, context);
    if (res != null) {
      console('res is not null...............................xx');
      if (res is String) {
        StorageService.setString('user_uid', res);
        return Checking.doNotProceed;
      } else if (res is Map && !res.keys.contains('checking')) {
        console('res is map and setting user info...................');
        StorageService.setJson('user', res);
        StorageService.setJson('principal_user', res['principal']);
        StorageService.get.setUser(res['principal']);
        console('.............xxxx.......${StorageService.get.user?.toJson()}');

        var permissions = res['principal']?['authorities'];
        Permissions.instance()
            .setAuthorities(List<Map<String, dynamic>>.from(permissions ?? []));
        if (res['principal']['firstLogin'] == true) {
          return Checking.firstLogin;
        } else if (res['principal']['passwordExpiresAt'] != null &&
            DateTime.parse(res['principal']['passwordExpiresAt'])
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
              Navigator.pop(NavigationService.get.currentContext!, true);
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
              Navigator.pop(NavigationService.get.currentContext!, true);
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
              Navigator.pop(NavigationService.get.currentContext!, true);
            });
        return Checking.otpExpired;
      }
    }

    return Checking.stay;
  }

  Future<Checking> changePassword(BuildContext context,
      {required String uid,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    var res = await changeUserPassword(
        url:
            '${portChecking(Environment.getInstance().getServerUrlPort())}/user/changePassword',
        data: {
          'uid': uid,
          'currentPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword
        },
        context);
    console(res);

    if (res != null) {
      StorageService.setString('user_uid', null);
      NotificationService.snackBarSuccess(
          context: context, title: 'Password Changed Successfully');
      return Checking.proceed;
    }
    NotificationService.snackBarError(
        context: context, title: 'Password  Unsuccessfully Changed');
    return Checking.doNotProceed;
  }

  Future<bool> logoutUser(BuildContext context,
      {required String accessToken, required String refreshToken}) async {
    var jsonToken = await StorageService.getJson('user_token');
    if (jsonToken == null || jsonToken.isEmpty) {
      StorageService.setString('user_token', null);
      return true;
    }
    Token t = Token.fromJson(jsonToken);
    var res = await logOut(
      context,
      data: {'token': t.accessToken, 'refresh-token': t.refreshToken},
      url:
          '${portChecking(Environment.getInstance().getServerUrlPort())}/oauth/token/revoke',
    );
    if (res != null && res['status'] == true) {
      StorageService.setJson('user_token', {});
      StorageService.setJson('user', {});
      return true;
    }
    return false;
  }

  Future logOut(
    BuildContext context, {
    required String url,
    dynamic data,
  }) async {
    String token = await api.userToken(false, context);
    Options options = Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    try {
      var result = await http.post(
        Environment.getInstance().getServerUrl()! + url,
        data: data,
        options: options,
      );
      Map<String, dynamic> res = jsonDecode(result.toString());
      if (res['access_token'] != null ||
          res['error_description'] != null ||
          res['principal'] != null) {
        return res;
      }
      if (res['status'] == false) {
        NotificationService.snackBarError(
          context: context,
          title: res['message'],
        );
      }
      console('...........................$res');
      return res;
    } on DioException catch (e) {
      if (e.response != null) {
        var res = e.response!.data as Map<String, dynamic>;
        if (res['error_description'] != null) {
          NotificationService.snackBarError(
              context: context,
              title: res['error'],
              subTitle: res['error_description']);
          return null;
        }
        if (res['status'] == false) {
          NotificationService.snackBarError(
            context: context,
            title: res['message'],
          );
        }
        return res['data'];
      } else if (e.type == DioExceptionType.connectionTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Connection timed out',
            subTitle: 'Please make sure you are connected to the Internet');
        return e.message;
      } else if (e.type == DioExceptionType.receiveTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Receiver timed out',
            subTitle: 'There might be a problem with your Servers');
        return e.message;
      } else if (e.type == DioExceptionType.sendTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Sender timed out',
            subTitle:
                'There might be a problem with your Connection or something');
        return e.message;
      }
      return e.message;
    }
  }

  Future changeUserPassword(
    BuildContext context, {
    required String url,
    dynamic data,
  }) async {
    console('Starting to change....');
    String token = await api.userToken(false, context);
    Options options = Options(contentType: 'application/json', headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    try {
      var result = await http.post(
        Environment.getInstance().getServerUrl()! + url,
        data: data,
        options: options,
      );
      console('$result these are results');
      Map<String, dynamic> res = jsonDecode(result.toString());

      if (res['status'] == false) {
        NotificationService.snackBarError(
          context: context,
          title: res['message'],
        );
      }
      return res;
    } on DioException catch (e) {
      if (e.response != null) {
        var res = e.response!.data as Map<String, dynamic>;
        if (res['error_description'] != null) {
          NotificationService.snackBarError(
              context: context,
              title: res['error'],
              subTitle: res['error_description']);
          return null;
        }
        if (res['status'] == false) {
          NotificationService.snackBarError(
            context: context,
            title: res['message'],
          );
        }
        return res['data'];
      } else if (e.type == DioExceptionType.connectionTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Connection timed out',
            subTitle: 'Please make sure you are connected to the Internet');
        return e.message;
      } else if (e.type == DioExceptionType.receiveTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Receiver timed out',
            subTitle: 'There might be a problem with your Servers');
        return e.message;
      } else if (e.type == DioExceptionType.sendTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Sender timed out',
            subTitle:
                'There might be a problem with your Connection or something');
        return e.message;
      }
      return e.message;
    }
  }
}
