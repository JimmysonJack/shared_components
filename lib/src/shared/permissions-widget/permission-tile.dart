import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'permission-controler.dart';
import 'dart:math';

class PermissionTile extends StatefulWidget {
  final Widget bodyWidget;
  final int? activeElement;
  final String titleValue;

  final List<ActionButtonItem>? actionButton;
  final Function()? onSetPermission;
  final bool Function()? onExpansion;
  final SwitchController? controller;
  final ChangeDetectController? changeController;

  const PermissionTile(
      {super.key,
      required this.bodyWidget,
      this.activeElement,
      this.changeController,
      this.onExpansion,
      this.controller,
      this.actionButton,
      required this.onSetPermission,
      required this.titleValue});

  @override
  State<PermissionTile> createState() => _PermissionTileState();
}

class _PermissionTileState extends State<PermissionTile>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool loading = false;
  bool toggleStatus = false;
  final dataTableController = Get.put(DataTableController());
  final permissionController = Get.put(PermissionController());

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _animation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));
  @override
  void initState() {
    // widget.changeController!.addListener(() {
    //   widget.changeController.value
    //  })
    super.initState();
  }

  String generateRandomKey(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardElevation = isExpanded ? 5.0 : 1.0;
    return Card(
      elevation: cardElevation,
      child: ExpansionTile(
        onExpansionChanged: (bool expanded) {
          if (expanded) {
            toggleStatus = widget.onExpansion!();
          }
          setState(() {
            isExpanded = expanded;
            expanded ? _controller.forward() : _controller.reverse();
          });
        },
        title: widget.activeElement != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.titleValue),
                  GText(
                    '${widget.activeElement} Active',
                    color: ThemeController.getInstance().darkMode(
                        darkColor: Colors.white24, lightColor: Colors.black26),
                  )
                ],
              )
            : Text(widget.titleValue),
        children: [
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _animation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  widget.bodyWidget,
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => permissionController.onLoad.value &&
                          widget.changeController!.value
                      ? IndicateProgress.cardLinear('Setting Permission')
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Obx(() {
                            permissionController.checkboxValue.value;
                            permissionController.changeDetected.value;
                            console(permissionController.changeDetected.value);

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Check All',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Switch(
                                        value: toggleStatus,
                                        onChanged: (value) {
                                          toggleStatus = value;
                                          permissionController
                                                  .checkboxValue.value =
                                              !permissionController
                                                  .checkboxValue.value;
                                          widget.controller!.toggle(value
                                              ? SwitchState.on
                                              : SwitchState.off);
                                        })
                                  ],
                                ),
                                SizedBox(
                                    width: 150,
                                    child: Button(
                                      labelText: 'Set Permission',
                                      onPressed:
                                          widget.changeController!.value &&
                                                  permissionController
                                                      .changeDetected.value
                                              ? widget.onSetPermission
                                              : null,
                                    ))
                              ],
                            );
                          }))),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
