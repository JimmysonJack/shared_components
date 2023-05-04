// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/service/auth_service.dart';
import 'package:shared_component/src/service/storage_service.dart';

import '../utils/size_config.dart';
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
    final authService = Get.put(AuthServiceController());
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
    final authService = Get.put(AuthServiceController());
    if (await authService.logoutUser(context,
        accessToken: 'accessToken', refreshToken: 'refreshToken')) {
      if (navigateTo.isNotEmpty) Modular.to.navigate(navigateTo);
    }
  }

  Future<Checking> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final authService = Get.put(AuthServiceController());
    return await authService.changePassword(context,
        uid: getUser()['uid'],
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
  }

  Size sizeByScreenWidth(
      {required double max,
      required double min,
      double? maxWidthScreenSize,
      double? minWidthScreenSize}) {
    double maxScreenSizeWidth = maxWidthScreenSize ?? 600;
    double minScreenSizeWidth = minWidthScreenSize ?? 300;
    var factor = SizeConfig.fullScreen.width >= maxScreenSizeWidth
        ? 1
        : SizeConfig.fullScreen.width <= minScreenSizeWidth
            ? 0
            : (SizeConfig.fullScreen.width - minScreenSizeWidth) /
                (maxScreenSizeWidth - minScreenSizeWidth);
    var width = min + (max - min) * factor;
    var height = 0.5 * width;
    console(
        'min width is $minWidthScreenSize width is $width factor is $factor');
    return Size(width, height);
  }

  permissionCheck(List<String> searchList) {
    var user = Permissions.instance().getAuthorities();
    List<Map<String, dynamic>> userAuthorities =
        List<Map<String, dynamic>>.from(user ?? []);
    if (userAuthorities.isEmpty) {
      userAuthorities = [
        {'authority': 'ACCESS_USER'},
        {'authority': 'ACCESS_ROLE'},
        {'authority': 'ACCESS_DASHBOARD'},
        {'authority': 'ACCESS_FUND'}
      ];
    }

    bool found = searchList.isNotEmpty &&
        searchList.any((searchElement) => userAuthorities
            .where((element) => element["authority"] == searchElement)
            .isNotEmpty);

    return found;
  }
}
