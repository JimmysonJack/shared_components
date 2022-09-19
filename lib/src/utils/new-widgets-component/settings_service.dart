import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_component/src/service/auth_service.dart';
import 'package:shared_component/src/service/storage_service.dart';

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
    return principal?['principal']?['name'];
  }

  login({required String userName, required String password, String? navigateTo,required BuildContext context})async{
    AuthServiceStore authService = AuthServiceStore();
    authService.getContext(context);
    if(await authService.loginUser(username: userName, password: password,showLoading: true)){
      if (await authService.getUser() == Checking.proceed) {
        if(navigateTo != null) Modular.to.navigate(navigateTo);
      }
    }
  }

  logout(String navigateTo)async{
    AuthServiceStore authService = AuthServiceStore();
    if (await authService.logoutUser(accessToken: 'accessToken', refreshToken: 'refreshToken')) {
      if(navigateTo.isNotEmpty) Modular.to.navigate(navigateTo);
    }
  }

  changePassword({required String oldPassword, required String newPassword, required String confirmPassword, required BuildContext context})async{
    AuthServiceStore authService = AuthServiceStore();
    authService.getContext(context);
    if(await authService.changePassword(uid: getUser()['uid'], oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword)){
      Modular.to.pop();
    }

  }
}
