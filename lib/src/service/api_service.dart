// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_component/shared_component.dart';
import 'package:get/get.dart';

typedef DynamicFunction = void Function(dynamic);

class Api {
  final http = Dio();
  dynamic authService = {};

  Future<String> userToken(bool login, BuildContext? context) async {
    userLogin(context);
    var jsonToken = await StorageService.getJson('user_token');
    if (jsonToken == null || jsonToken.isEmpty) {
      if (login) {
        return await userLogin(context);
      }
      return '';
    } else {
      Token t = Token.fromJson(jsonToken);
      if (t.expiresAt != null && t.expiresAt!.isAfter(DateTime.now())) {
        return t.accessToken!;
      } else if (login) {
        return await refreshToken(t, context!);
      } else {
        return '';
      }
    }
  }

  Future<String> userLogin(BuildContext? context) async {
    var mediaQuery = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var principal = await StorageService.getJson('user');
    String? userName;
    String? userEmail;
    if (principal.isNotEmpty) {
      userName = principal['principal']['name'];
      userEmail = principal['principal']['email'];
    }
    if (ModalState.modal().modelIsOpened == false) {
      ModalState.modal().modelIsOpened = true;
      await Future.delayed(const Duration(seconds: 5), () {
        ModalState.modal().modelIsOpened = false;
      });
      Get.dialog(SizedBox(
        width: mediaQuery.size.width / 3.5,
        child: Observer(builder: (context) {
          return SimpleDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userName == null ? 'LOGIN' : 'Confirm Your Identity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  userName ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                    ),
                    obscureText: true,
                    onChanged: authService.setPass,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password must be provided';
                      }
                      return null;
                    })
              ],
            ),
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (authService.loading) IndicateProgress.linear(),
                            Field.use.button(
                              widthSize: WidthSize.col12,
                              validate: false,
                              label: 'Confirm',
                              onPressed: authService.passwordHasError
                                  ? null
                                  : authService.loading
                                      ? null
                                      : () async {
                                          authService.setLoading(true);
                                          if (await authService.loginUser(
                                              context,
                                              username:
                                                  userEmail ?? 'root@janju.com',
                                              password:
                                                  authService.passwordValue!)) {
                                            authService.setLoading(false);
                                            Modular.to.pop();
                                          } else {
                                            authService.setLoading(false);
                                          }
                                        },
                              context: context,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!authService.loading)
                          Field.use.button(
                            widthSize: WidthSize.col12,
                            validate: false,
                            label: 'Go To Start Over',
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            onPressed: () async {
                              var jsonToken =
                                  await StorageService.getJson('user_token');
                              if (jsonToken.isNotEmpty) {
                                Token t = Token.fromJson(jsonToken);
                                authService.logoutUser(context,
                                    accessToken: t.accessToken!,
                                    refreshToken: t.refreshToken!);
                              } else {
                                Modular.to.navigate('/login/');
                              }
                            },
                            context: context,
                          )
                      ],
                    ),
                  )),
            ],
          );
        }),
      ));
    }
    return '';
  }

  Future<String> refreshToken(Token token, BuildContext context) async {
    Options requestOptions =
        Options(contentType: 'application/x-www-form-urlencoded', headers: {
      'Accept': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${Environment.getInstance().getClientId()}:${Environment.getInstance().getClientSecret()}'))}'
    });
    Map<String, dynamic>? res = await post(
        '/oauth/token',
        {'grant_type': 'refresh_token', 'refresh_token': token.refreshToken},
        context,
        options: requestOptions);
    if (res?['access_token'] != null) {
      Token token = Token.fromJson(res!);
      StorageService.setJson('user_token', token.toJson());
      return token.accessToken!;
    }
    return userLogin(context);
  }

  Future<String> clientToken(BuildContext context) async {
    var jsonToken = await StorageService.getJson("client_token");
    if (jsonToken == null || jsonToken.isEmpty) {
      return await clientLogin(context);
    } else {
      Token t = Token.fromJson(jsonToken);
      if (t.expiresAt != null && t.expiresAt!.isAfter(DateTime.now())) {
        return t.accessToken!;
      } else {
        return await clientLogin(context);
      }
    }
  }

  Future<String> clientLogin(BuildContext context) async {
    Options requestOptions =
        Options(contentType: 'application/x-www-form-urlencoded', headers: {
      'Accept': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${Environment.getInstance().getClientId()}:${Environment.getInstance().getClientSecret()}'))}'
    });
    Map<String, dynamic> res = await request(context,
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

  Future request(BuildContext context,
      {required String type,
      required String url,
      dynamic data,
      required Options options}) async {
    try {
      var result = type == 'post'
          ? await http.post(
              Environment.getInstance().getServerUrl()! + url,
              data: data,
              options: options,
            )
          : await http.get(Environment.getInstance().getServerUrl()! + url,
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
          await refreshToken(token, context);
          options.headers!['Authorization'] =
              'Bearer ${await userToken(false, context)}';
          return request(context,
              type: type, url: url, data: data, options: options);
        } else if (res['message'].contains('First login')) {
          return {
            'checking': Checking.firstLogin,
            'userUid': res['data']
          }; //data is user uid
        } else if (res['message'].contains('Password Expired')) {
          return {
            'checking': Checking.passwordExpired,
            'userUid': res['data']
          }; // we are expecting to get user uid in [res['data']]
        } else if (res['message'] == 'OTP Expired') {
          return Checking
              .otpExpired; // this will be returned when one time password is expired
        }
        NotificationService.snackBarError(
          context: context,
          title: res['message'],
        );
      }
      return res['data'];
    } on DioError catch (e) {
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
          if (res['message'].contains("Invalid access token")) {
            await clientLogin(context);
            options.headers!['Authorization'] =
                'Bearer ${await clientToken(context)}';
            return request(context,
                type: type, url: url, data: data, options: options);
          } else {
            NotificationService.snackBarError(
              context: context,
              title: res['message'],
            );
          }
        }
        return res['data'];
      } else if (e.type == DioErrorType.connectTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Connection timed out',
            subTitle: 'Please make sure you are connected to the Internet');
        return e.message;
      } else if (e.type == DioErrorType.receiveTimeout) {
        NotificationService.snackBarError(
            context: context,
            title: 'Receiver timed out',
            subTitle: 'There might be a problem with your Servers');
        return e.message;
      } else if (e.type == DioErrorType.sendTimeout) {
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

  Future post(String url, dynamic data, BuildContext context,
      {Options? options}) async {
    String token = await userToken(false, context);
    if (token == '') token = await clientToken(context);
    return request(context,
        type: 'post',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
  }

  Future clientPost(String url, dynamic data, BuildContext context) async {
    return request(context,
        type: 'post',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await clientToken(context)}'
        }));
  }

  Future userPost(String url, dynamic data, BuildContext context) async {
    return request(context,
        type: 'post',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await userToken(true, context)}'
        }));
  }

  Future get(String url, BuildContext context, {dynamic data}) async {
    String token = await userToken(false, context);
    if (token == '') token = await clientToken(context);
    return request(context,
        type: 'get',
        url: url,
        data: data,
        options: Options(contentType: 'application/json', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
  }

  void cacheGet(String url, DynamicFunction callBack, BuildContext context,
      {dynamic data}) async {
    Map<String, dynamic> cache = await StorageService.getJson('cache') ?? {};
    if (cache[url] != null) {
      callBack(cache[url]);
    }
    dynamic storedData = await get(url, context, data: data);
    cache[url] = storedData;
    StorageService.setJson('cache', cache);
    callBack(storedData);
  }

  void invalidateToken(String token) async {
    Map<String, dynamic> token =
        await StorageService.getJson("user_token") ?? {};
    if (token['access_token'] == token) {
      StorageService.setJson('user_token', null);
    } else {
      token = await StorageService.getJson("client_token") ?? {};
      if (token['access_token'] == token) {
        StorageService.setJson('client_token', null);
      }
    }
  }
}

class ModalState {
  static ModalState? _instance;
  bool modelIsOpened = false;
  static ModalState modal() {
    _instance ??= ModalState();
    return _instance!;
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
