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
    this.roleUidFieldName,
  }) : super(key: key);

  final String endPointName;
  final String roleUid;
  final String? roleUidFieldName;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => permissionController.loadingOnGetPermissions.value
        ? IndicateProgress.cardLinear('Loading Permissions')
        : ListView.builder(
            shrinkWrap: true,
            itemCount: permissionController.permissionList.length,
            itemBuilder: (BuildContext context, int index) {
              switchController = SwitchController(SwitchState.nothing);
              changeDetectController = ChangeDetectController(false);
              dataInstance = DataInstance();
              SelectedPermissions? selectedPermissions = SelectedPermissions();
              return PermissionTile(
                changeController: changeDetectController,
                controller: switchController,
                activeElement: permissionController.permissionList[index]
                        ['permissions']
                    .where((element) => element['isAllowed'] == true)
                    .length,
                onSetPermission: () {
                  permissionController.onLoad.value = true;
                  GraphQLService.mutate(
                      response: (data, loading) {
                        permissionController.onLoad.value = false;
                      },
                      endPointName: widget.endPointName,
                      queryFields: 'uid',
                      inputs: [
                        InputParameter(
                            fieldName: 'uid',
                            inputType: 'String',
                            fieldValue:
                                selectedPermissions.selectedPermissionUids),
                        InputParameter(
                            fieldName: 'roleUid',
                            inputType: 'String',
                            fieldValue: widget.roleUid),
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
                  selectedPermissions: selectedPermissions,
                  changeController: changeDetectController,
                  dataInstance: dataInstance,
                  controller: switchController,
                  dataList: List<Map<String, dynamic>>.from(permissionController
                      .permissionList[index]['permissions']),
                  selectedTileIndex: () => index,
                ),
                titleValue: permissionController.permissionList[index]
                        ['groupName'] ??
                    'is Empty',
                // titleValue: widget.dataList[index][widget.titleKey],
              );
            },
          ));
  }
}
