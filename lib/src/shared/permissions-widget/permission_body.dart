// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'permission_controler.dart';

class PermissionBody extends StatefulWidget {
  PermissionBody({
    super.key,
    this.initialSelectedValue = false,
    required this.selectedTileIndex,
    required this.dataList,
    this.changeController,
    this.selectedPermissions,
    required this.dataInstance,
    this.controller,
  });
  bool initialSelectedValue;
  List<Map<String, dynamic>> dataList;
  final int Function() selectedTileIndex;
  final ChangeDetectController? changeController;

  /// This [controller] is used to receive a [SwitchState] which helps us to check or uncheck all permissions
  final SwitchController? controller;

  /// This [dataInstance] is used to store data of every instance of [PermissionBody]
  final DataInstance? dataInstance;

  /// this [selectedPermissions] is used to capture and remove all the selected permissions.
  final SelectedPermissions? selectedPermissions;

  @override
  State<PermissionBody> createState() => _PermissionBodyState();
}

class _PermissionBodyState extends State<PermissionBody> {
  int selectedIndex = -1;

  final PermissionController permissionController =
      Get.put(PermissionController());

  @override
  void initState() {
    widget.dataInstance!.setData = widget.dataList
        .map((e) => {
              'uid': e['uid'],
              'isAllowed': e['isAllowed'],
              'refKey': e['isAllowed']
            })
        .toList();
    bool stopRun = false;
    widget.controller!.addListener(() {
      if (!stopRun) {
        if (widget.controller!.value == SwitchState.on) {
          widget.dataList = widget.dataList.map((e) {
            if (!widget.dataInstance!.getData![widget.dataList.indexOf(e)]
                ['isAllowed']) {
              widget.selectedPermissions!.setAndRemovePermission(e['uid']);
              e['isAllowed'] = true;
            } else if (widget.dataInstance!.getData!
                .every((element) => element['isAllowed'] == true)) {
              widget.selectedPermissions!.setAndRemovePermission(e['uid']);
              e['isAllowed'] = true;
            }
            return e;
          }).toList();
        } else {
          widget.dataList = widget.dataList.map((e) {
            if (!widget.dataInstance!.getData![widget.dataList.indexOf(e)]
                ['isAllowed']) {
              widget.selectedPermissions!.setAndRemovePermission(e['uid']);
              e['isAllowed'] = false;
            } else if (widget.dataInstance!.getData!
                .every((element) => element['isAllowed'] == true)) {
              widget.selectedPermissions!.setAndRemovePermission(e['uid']);
              e['isAllowed'] = false;
            }
            return e;
          }).toList();
        }
        stopRun = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          stopRun = false;
        });
      }

      changeDetected('isAllowed');
    });
    super.initState();
  }

  changeDetected(String key) {
    permissionController.changeDetected.value = !widget.dataInstance!.getData!
        .every((insElement) => widget.dataList
            .where((element) =>
                element[key] == insElement[key] &&
                element['uid'] == insElement['uid'])
            .isNotEmpty);
    widget.changeController!.check(permissionController.changeDetected.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        alignment: WrapAlignment.start,
        children: List.generate(
            widget.dataList.length,
            (index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      permissionController.checkboxValue.value;
                      return Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          value: widget.dataList[index]['isAllowed'],
                          onChanged: widget.changeController!.value &&
                                  permissionController.onLoad.value
                              ? null
                              : (value) {
                                  bool selected =
                                      widget.dataList[index]['isAllowed'];
                                  widget.dataList[index]['isAllowed'] =
                                      !selected;
                                  permissionController.checkboxValue.value =
                                      !permissionController.checkboxValue.value;
                                  changeDetected('isAllowed');
                                  widget.selectedPermissions!
                                      .setAndRemovePermission(
                                          widget.dataList[index]['uid']);
                                  // widget.dataInstance!.setData = widget.dataList
                                  //     .map((e) => {
                                  //           'uid': e['uid'],
                                  //           'isAllowed': e['isAllowed'],
                                  //           'refKey': !selected
                                  //         })
                                  //     .toList();
                                });
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    GText(widget.dataList[index]['displayName'])
                  ],
                )),
      ),
    );
  }
}
