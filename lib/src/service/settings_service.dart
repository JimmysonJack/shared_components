// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/service/auth_service.dart';
import 'package:shared_component/src/service/storage_service.dart';

import 'notification_service.dart';

class SettingsService {
  static SettingsService use = SettingsService();
  List<Map<String, dynamic>> convertMapToList(data) {
    List<Map<String, dynamic>> dataList = [];
    if (data != null) {
      Map newData = data;
      newData.removeWhere((key, value) => key == '__typename');
      for (var element in newData.keys) {
        dataList.add({element.toString(): newData[element]});
      }
    }
    return dataList;
  }

  getUser() async {
    var principal = await StorageService.getJson('user');
    return principal?['principal'];
  }

  Future<Checking> login(
      {required String userName,
      required String password,
      String? navigateTo,
      required BuildContext context}) async {
    AuthServiceStore authService = AuthServiceStore();
    if (await authService.loginUser(context,
            username: userName, password: password, showLoading: true) ==
        Checking.proceed) {
      Checking userState = await authService.getUser(context);
      if (userState == Checking.proceed) {
        if (navigateTo != null) Modular.to.navigate(navigateTo);
        return userState;
      } else if (userState == Checking.firstLogin) {
        await NotificationService.confirmWarn(
            context: context,
            title: 'First Login Detected',
            content:
                'In order to proceed, you are advised to change your Password first',
            onConfirmBtnTap: () {
              Navigator.pop(context, true);
            });
        return Checking.firstLogin;
      } else if (userState == Checking.passwordExpired) {
        await NotificationService.confirmWarn(
            context: context,
            title: 'Password Expiration Detected',
            content:
                'In order to proceed, you are advised to change your Password first',
            onConfirmBtnTap: () {
              Navigator.pop(context, true);
            });
        return Checking.passwordExpired;
      } else if (userState == Checking.otpExpired) {
        await NotificationService.confirmWarn(
            context: context,
            title: 'One Time Password (OTP)',
            content:
                'It seems like OTP is expired, you are advised to contact System Adminstrator',
            onConfirmBtnTap: () {
              Navigator.pop(context, true);
            });
        return Checking.otpExpired;
      }
      return Checking.stay;
    }
    return Checking.stay;
  }

  logout(String navigateTo, BuildContext context) async {
    AuthServiceStore authService = AuthServiceStore();
    if (await authService.logoutUser(context,
        accessToken: 'accessToken', refreshToken: 'refreshToken')) {
      if (navigateTo.isNotEmpty) Modular.to.navigate(navigateTo);
    }
  }

  changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    AuthServiceStore authService = AuthServiceStore();
    if (await authService.changePassword(context,
        uid: getUser()['uid'],
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword)) {
      Modular.to.pop();
    }
  }
}
