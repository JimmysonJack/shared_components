import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'permission-body.dart';
import 'permission-controler.dart';
import 'permission-tile.dart';

class PermissionSettings extends StatefulWidget {
  const PermissionSettings({
    Key? key,
    // required this.dataList,
    required this.titleKey,
    required this.endPointName,
  }) : super(key: key);

  // final List<dynamic> dataList;
  final String titleKey;
  final String endPointName;

  @override
  _PermissionSettingsState createState() => _PermissionSettingsState();
}

class _PermissionSettingsState extends State<PermissionSettings> {
  int selectedIndex = -1;
  final PermissionController permissionController =
      Get.put(PermissionController());
  SwitchController? switchController;
  DataInstance? dataInstance;
  ChangeDetectController? changeDetectController;

  @override
  void initState() {
    permissionController.createPermissionMatrix();
    super.initState();
  }

  @override
  void dispose() {
    switchController!.dispose();
    changeDetectController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return permissionController.permissionList.isEmpty
        ? IndicateProgress.circular()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: permissionController.permissionList.value.length,
            itemBuilder: (BuildContext context, int index) {
              switchController = SwitchController(SwitchState.nothing);
              changeDetectController = ChangeDetectController(false);
              dataInstance = DataInstance();
              SelectedPermissions? selectedPermissions = SelectedPermissions();
              return PermissionTile(
                changeController: changeDetectController,
                controller: switchController,
                activeElement: permissionController
                    .permissionList.value[index]['permission']
                    .where((element) => element['isAllowed'] == true)
                    .length,
                onSetPermission: () {
                  permissionController.onLoad.value = true;
                  // console(selectedPermissions.selectedPermissionUids);
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
                                selectedPermissions.selectedPermissionUids)
                      ],
                      context: context);
                },
                onExpansion: () {
                  permissionController.selectedPermission.value =
                      permissionController.permissionList.value[index]
                          ['permission'];

                  return permissionController.permissionList.value[index]
                      ['toggle'];
                },
                // selectedData: widget.dataList[index],
                bodyWidget: PermissionBody(
                  selectedPermissions: selectedPermissions,
                  changeController: changeDetectController,
                  dataInstance: dataInstance,
                  controller: switchController,
                  dataList: permissionController.permissionList.value[index]
                      ['permission'],
                  selectedTileIndex: () => index,
                ),
                titleValue: permissionController.permissionList.value[index]
                        ['groupName'] ??
                    'is Empty',
                // titleValue: widget.dataList[index][widget.titleKey],
              );
            },
          );
  }
}
