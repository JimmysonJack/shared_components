// ignore_for_file: must_be_immutable

import 'dart:collection';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'permission_controler.dart';

class PermissionBody extends StatefulWidget {
  PermissionBody({
    super.key,
    this.initialSelectedValue = false,
    required this.permissionController,
    required this.selectedTileIndex,
    required this.dataObject,
    this.changeController,
    this.selectedPermissions,
    required this.dataInstance,
    this.controller,
  });
  bool initialSelectedValue;
  Map<String, dynamic> dataObject;
  final int Function() selectedTileIndex;
  final PermissionController permissionController;
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

  @override
  void didUpdateWidget(covariant PermissionBody oldWidget) {
    setInitialData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    setInitialData();

    super.initState();
  }

  listener() {
    bool stopRun = false;
//  if(widget.controller?.hasListeners == false){}

    widget.controller!.addListener(() {
      if (!stopRun) {
        if (widget.controller!.value == SwitchState.on) {
          widget.dataObject['permissions'] =
              widget.dataObject['permissions'].map((e) {
            if (!widget.dataInstance!
                    .getData![widget.dataObject['permissions'].indexOf(e)]
                ['isAllowed']) {
              widget.selectedPermissions!.setAndRemovePermission({
                'groupName': widget.dataObject['groupName'],
                'uid': e['uid']
              });
              e['isAllowed'] = true;
            } else if (widget.dataInstance!.getData!
                .every((element) => element['isAllowed'] == true)) {
              widget.selectedPermissions!.setAndRemovePermission({
                'groupName': widget.dataObject['groupName'],
                'uid': e['uid']
              });
              e['isAllowed'] = true;
            }
            return e;
          }).toList();
        } else {
          widget.dataObject['permissions'] =
              (widget.dataObject['permissions'] as List).map((e) {
            if (!widget.dataInstance!
                    .getData![widget.dataObject['permissions'].indexOf(e)]
                ['isAllowed']) {
              widget.selectedPermissions!.setAndRemovePermission({
                'groupName': widget.dataObject['groupName'],
                'uid': e['uid']
              });
              e['isAllowed'] = false;
            } else if (widget.dataInstance!.getData!
                .every((element) => element['isAllowed'] == true)) {
              widget.selectedPermissions!.setAndRemovePermission({
                'groupName': widget.dataObject['groupName'],
                'uid': e['uid']
              });
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

      changeDetected('isAllowed', widget.dataObject['groupName']);
    });
  }

  setInitialData() {
    ///Clearing [selectedGroupPermissionUids] in order to start a fresh every time state changes
    widget.selectedPermissions?.selectedGroupPermissionUids.clear();
    widget.dataInstance!.setData = List<Map<String, dynamic>>.from(
        widget.dataObject['permissions'].map((e) {
      if (e['isAllowed']) {
        widget.selectedPermissions!.setAndRemovePermission(
            {'groupName': widget.dataObject['groupName'], 'uid': e['uid']});
        console(widget.selectedPermissions?.selectedGroupPermissionUids);
      }
      return {
        'uid': e['uid'],
        'isAllowed': e['isAllowed'],
        'refKey': e['isAllowed']
      };
    }).toList());
    listener();
  }

  changeDetected(String key, groupName) {
    // bool isChanged = false;
    bool isChanged = !widget.dataInstance!.getData!.every((elementA) =>
        (widget.dataObject['permissions'] as List).any((elementB) =>
            elementA[key] == elementB[key] &&
            elementA['uid'] == elementB['uid']));

    if (widget.permissionController.changeDetected
        .where((element) => (element as Map).keys.first == groupName)
        .isNotEmpty) {
      widget.permissionController.changeDetected.value =
          widget.permissionController.changeDetected.map((element) {
        if ((element as Map).keys.first == groupName) {
          element[groupName] = isChanged;
        }
        return element;
      }).toList();
    } else {
      widget.permissionController.changeDetected.add({groupName: isChanged});
    }
    List<Map<String, dynamic>> dataList = [];
    for (var element in widget.permissionController.changeDetected) {
      dataList.add((element as LinkedHashMap).cast<String, dynamic>());
    }

    bool status = SettingsService.use
        .getSingleValueFromListOfMapByKey(dataList, groupName);
    widget.changeController!.check(status);
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
            widget.dataObject['permissions'].length,
            (index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      widget.permissionController.checkboxValue.value;
                      return Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          value: widget.dataObject['permissions'][index]
                              ['isAllowed'],
                          onChanged: widget.changeController!.value &&
                                  widget.permissionController.onSavingPermission
                                      .firstWhereOrNull((element) =>
                                          (element as Map).containsKey(widget
                                              .dataObject['groupName']))?[widget
                                      .dataObject['groupName']]
                              ? null
                              : (value) {
                                  bool selected =
                                      widget.dataObject['permissions'][index]
                                          ['isAllowed'];
                                  widget.dataObject['permissions'][index]
                                      ['isAllowed'] = !selected;
                                  widget.permissionController.checkboxValue
                                          .value =
                                      !widget.permissionController.checkboxValue
                                          .value;
                                  changeDetected('isAllowed',
                                      widget.dataObject['groupName']);
                                  widget.selectedPermissions!
                                      .setAndRemovePermission({
                                    'groupName': widget.dataObject['groupName'],
                                    'uid': widget.dataObject['permissions']
                                        [index]['uid']
                                  });
                                  widget.permissionController.activateTheToggle[
                                      widget.selectedTileIndex()] = (widget
                                          .dataObject['permissions'] as List)
                                      .every((element) => element['isAllowed']);
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
                    GText(
                        widget.dataObject['permissions'][index]['displayName'])
                  ],
                )),
      ),
    );
  }
}
