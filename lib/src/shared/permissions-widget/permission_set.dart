import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'permission_body.dart';
import 'permission_controler.dart';
import 'permission_tile.dart';

class PermissionSettings extends StatefulWidget {
  const PermissionSettings({
    Key? key,
    required this.endPointName,
    required this.roleUid,
    required this.roleFieldName,
    required this.roleFieldType,
    required this.permissionsFieldName,
    required this.permissionsFieldType,
  }) : super(key: key);

  final String endPointName;
  final String roleUid;
  final String roleFieldName;
  final String roleFieldType;
  final String permissionsFieldName;
  final String permissionsFieldType;

  @override
  PermissionSettingsState createState() => PermissionSettingsState();
}

class PermissionSettingsState extends State<PermissionSettings> {
  int selectedIndex = -1;
  final PermissionController permissionController =
      Get.put(PermissionController());
  SwitchController? switchController;
  DataInstance? dataInstance;
  ChangeDetectController? changeDetectController;
  String? groupName;

  @override
  void initState() {
    permissionController.createPermissionMatrix(context, widget.roleUid);
    super.initState();
  }

  @override
  void dispose() {
    if (switchController != null) {
      switchController!.dispose();
    }
    if (changeDetectController != null) {
      changeDetectController!.dispose();
    }
    permissionController.selectedPermissions.selectedGroupPermissionUids
        .clear();
    permissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      permissionController.updatingPermissions.value;
      return permissionController.loadingOnGetPermissions.value
          ? IndicateProgress.cardLinear('Loading Permissions')
          : ListView.builder(
              shrinkWrap: true,
              itemCount: permissionController.permissionList.length,
              itemBuilder: (BuildContext context, int index) {
                permissionController.activateTheToggle.add(false);
                switchController = SwitchController(SwitchState.nothing);
                changeDetectController = ChangeDetectController(false);
                dataInstance = DataInstance();
                return PermissionTile(
                  permissionController: permissionController,
                  changeController: changeDetectController,
                  controller: switchController,
                  activeElement: permissionController.permissionList[index]
                          ['permissions']
                      .where((element) => element['isAllowed'] == true)
                      .length,
                  totalElement: permissionController
                      .permissionList[index]['permissions'].length,
                  onSetPermission: (groupName) {
                    this.groupName = groupName;
                    permissionController.onSavingPermission.value =
                        permissionController.onSavingPermission.map((element) {
                      if ((element as Map).containsKey(groupName)) {
                        element[groupName] = true;
                      }
                      return element;
                    }).toList();
                    GraphQLService.mutate(
                        response: (data, loading) {
                          permissionController.onSavingPermission.value =
                              permissionController.onSavingPermission
                                  .map((element) {
                            if ((element as Map).containsKey(groupName)) {
                              element[groupName] = false;
                            }
                            return element;
                          }).toList();
                          if (data != null) {
                            permissionController.createPermissionMatrix(
                                context, widget.roleUid,
                                showLoader: false);
                          }
                        },
                        endPointName: widget.endPointName,
                        queryFields: 'uid',
                        inputs: [
                          InputParameter(
                              fieldName: widget.permissionsFieldName,
                              inputType: widget.permissionsFieldType,
                              fieldValue: SettingsService.use
                                  .getSingleValueFromListOfMapByKey(
                                      permissionController.selectedPermissions
                                          .selectedGroupPermissionUids
                                          .where((element) =>
                                              element['groupName'] == groupName)
                                          .toList(),
                                      'permissions')),
                          InputParameter(
                              fieldName: widget.roleFieldName,
                              inputType: widget.roleFieldType,
                              fieldValue: widget.roleUid),
                          InputParameter(
                              fieldName: 'groupName',
                              inputType: 'String',
                              fieldValue: groupName),
                        ],
                        context: context);
                  },
                  onExpansion: () {
                    permissionController.selectedPermission.value =
                        List<dynamic>.from(permissionController
                            .permissionList[index]['permissions']);
                    return permissionController.permissionList[index]['toggle'];
                  },
                  // selectedData: widget.dataList[index],
                  bodyWidget: PermissionBody(
                    permissionController: permissionController,
                    selectedPermissions:
                        permissionController.selectedPermissions,
                    changeController: changeDetectController,
                    dataInstance: dataInstance,
                    controller: switchController,
                    dataObject: Map<String, dynamic>.from(
                        permissionController.permissionList[index]),
                    selectedTileIndex: () {
                      return index;
                    },
                  ),
                  tileIndex: index,
                  titleValue: permissionController.permissionList[index]
                          ['groupName'] ??
                      'is Empty',
                  // titleValue: widget.dataList[index][widget.titleKey],
                );
              },
            );
    });
  }
}
