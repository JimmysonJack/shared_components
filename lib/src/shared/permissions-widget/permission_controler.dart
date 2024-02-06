// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

class PermissionController extends GetxController {
  final checkboxValue = false.obs;
  List<Map<String, dynamic>> permissionList = [];
  SelectedPermissions selectedPermissions = SelectedPermissions();
  final selectedPermission = [].obs;

  final onSavingPermission = [].obs;
  final changeDetected = [].obs;
  final loadingOnGetPermissions = false.obs;
  final activateTheToggle = [].obs;
  final updatingPermissions = false.obs;

  List<Map<String, dynamic>> _permissionList = [];

  getPermissions(BuildContext context, roleUid,
      {bool showProgressLoader = true}) async {
    loadingOnGetPermissions.value = showProgressLoader;
    // _permissionList = await GraphQLService.query(
    //     fetchPolicy: FetchPolicy.networkOnly,
    //     endPointName: 'getPermissions',
    //     responseFields: 'groupName permissions{uid displayName name active}',
    //     context: context);
    final permissionList = await GraphQLService.query(
        fetchPolicy: FetchPolicy.networkOnly,
        endPointName: 'getPermissionsByRole',
        responseFields: 'groupName permissions{uid displayName name active}',
        parameters: [
          OtherParameters(
              keyName: 'roleUid', keyValue: roleUid, keyType: 'String')
        ],
        context: context);
    _permissionList = List<Map<String, dynamic>>.from(permissionList.data);
    loadingOnGetPermissions.value = false;
  }

  createPermissionMatrix(BuildContext context, roleUid,
      {bool showLoader = true}) async {
    await getPermissions(context, roleUid, showProgressLoader: showLoader);
    permissionList = _permissionList.map((e) {
      onSavingPermission.addIf(
          onSavingPermission
              .where((element) => (element as Map).containsKey(e['groupName']))
              .isEmpty,
          {e['groupName']: false});
      return <String, dynamic>{
        'groupName': e['groupName'],
        'permissions': e['permissions'].map((i) {
          // if (i['active']) {
          //   console(i);
          //   selectedPermissions.setAndRemovePermission(
          //       {'groupName': e['groupName'], 'uid': i['uid']});
          // }
          ///Registaring all Permissions in a change detector for secure navigating in groups of permissions without following the sequence.
          changeDetected.addIf(
              changeDetected
                  .where((item) => (item as Map).containsKey(e['groupName']))
                  .isEmpty,
              {e['groupName']: false});

          return <String, dynamic>{...i, 'isAllowed': i['active']};
        }).toList(),
        'toggle': e['permissions'].every((element) => element['active'] == true)
      };
    }).toList();
    if (!showLoader) {
      updatingPermissions.value = !updatingPermissions.value;
    }
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

class SelectedPermissions extends GetxController {
  // final List<String> selectedPermissionUids = [];
  List<Map<String, dynamic>> selectedGroupPermissionUids = [];

  void setAndRemovePermission(Map<String, dynamic> permission) {
    // Ensure required keys exist in the input
    if (!permission.containsKey('groupName') ||
        !permission.containsKey('uid')) {
      throw ArgumentError('permission must have groupName and uid keys');
    }

    final groupName = permission['groupName'];
    final uid = permission['uid'];

    // Find the existing group with the same groupName
    final existingGroupIndex = selectedGroupPermissionUids.indexWhere(
      (element) => element['groupName'] == groupName,
    );

    if (existingGroupIndex != -1) {
      final existingGroup = selectedGroupPermissionUids[existingGroupIndex];
      final permissionsList = existingGroup['permissions'] as List;

      // Remove or add the permission based on its presence
      if (permissionsList.contains(uid)) {
        permissionsList.remove(uid);
      } else {
        permissionsList.add(uid);
      }
    } else {
      // Add a new group with the permission
      selectedGroupPermissionUids.add({
        'groupName': groupName,
        'permissions': [uid]
      });
    }
  }
}
