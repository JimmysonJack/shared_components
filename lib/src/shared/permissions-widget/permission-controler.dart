// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

class PermissionController extends GetxController {
  final checkboxValue = false.obs;
  List<Map<String, dynamic>> permissionList = [];
  final selectedPermission = [].obs;

  final onLoad = false.obs;
  final changeDetected = false.obs;
  final loadingOnGetPermissions = false.obs;

  List<Map<String, dynamic>> _permissionList = [];

  getPermissions(BuildContext context, roleUid) async {
    loadingOnGetPermissions.value = true;
    // _permissionList = await GraphQLService.query(
    //     fetchPolicy: FetchPolicy.networkOnly,
    //     endPointName: 'getPermissions',
    //     responseFields: 'groupName permissions{uid displayName name active}',
    //     context: context);
    _permissionList = await GraphQLService.query(
        fetchPolicy: FetchPolicy.networkOnly,
        endPointName: 'getPermissionsByRole',
        responseFields: 'groupName permissions{uid displayName name active}',
        parameters: [
          OtherParameters(
              keyName: 'roleUid', keyValue: roleUid, keyType: 'String')
        ],
        context: context);
    loadingOnGetPermissions.value = false;
  }

  createPermissionMatrix(BuildContext context, roleUid) async {
    await getPermissions(context, roleUid);
    permissionList = _permissionList
        .map((e) => <String, dynamic>{
              'groupName': e['groupName'],
              'permissions': e['permissions']
                  .map((i) => <String, dynamic>{...i, 'isAllowed': i['active']})
                  .toList(),
              'toggle':
                  e['permissions'].every((element) => element['active'] == true)
            })
        .toList();
  }
}

class DataInstance {
  List<Map<String, dynamic>>? _dataList;
  set setData(List<Map<String, dynamic>> value) => _dataList = value;
  List<Map<String, dynamic>>? get getData => _dataList;
}

enum SwitchState { on, off, nothing }

class SwitchController extends ValueNotifier<SwitchState> {
  SwitchController(super.value);

  void toggle(SwitchState switchState) {
    value = switchState;
    notifyListeners();
  }
}

class ChangeDetectController extends ValueNotifier<bool> {
  ChangeDetectController(super.value);

  void check(bool changed) {
    value = changed;
    notifyListeners();
  }
}

class SelectedPermissions {
  final List<String> selectedPermissionUids = [];

  setAndRemovePermission(String permission) {
    if (selectedPermissionUids.contains(permission)) {
      selectedPermissionUids.remove(permission);
    } else {
      selectedPermissionUids.add(permission);
    }
  }
}
