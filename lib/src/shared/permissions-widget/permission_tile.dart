import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/utils/g_ui/g_text.dart';

import 'permission_controler.dart';
import 'dart:math';

class PermissionTile extends StatefulWidget {
  final Widget bodyWidget;
  final int? activeElement;
  final int? totalElement;
  final String titleValue;
  final int tileIndex;

  final List<ActionButtonItem>? actionButton;
  final Function(String)? onSetPermission;
  final bool Function()? onExpansion;
  final SwitchController? controller;
  final ChangeDetectController? changeController;
  final PermissionController permissionController;

  const PermissionTile(
      {super.key,
      required this.bodyWidget,
      required this.tileIndex,
      this.activeElement,
      this.totalElement,
      this.changeController,
      this.onExpansion,
      required this.permissionController,
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
  // bool toggleStatus = false;
  final dataTableController = Get.put(DataTableController());

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: const Icon(Icons.sync_lock),
        onExpansionChanged: (bool expanded) {
          if (expanded) {
            widget.permissionController.activateTheToggle[widget.tileIndex] =
                widget.onExpansion!();
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
                  Text(widget.titleValue.toString().replaceAll('_', ' ')),
                  GText(
                    '${widget.activeElement}/${widget.totalElement} Active',
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
                  Obx(() => widget.permissionController
                                  .onSavingPermission[widget.tileIndex]
                              [widget.titleValue] &&
                          widget.changeController!.value
                      ? IndicateProgress.cardLinear('Setting Permission')
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Obx(() {
                            widget.permissionController.checkboxValue.value;
                            widget.permissionController.changeDetected;

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
                                        value: widget.permissionController
                                                .activateTheToggle[
                                            widget.tileIndex],
                                        onChanged: (value) {
                                          widget.permissionController
                                                  .activateTheToggle[
                                              widget.tileIndex] = value;
                                          widget.permissionController
                                                  .checkboxValue.value =
                                              !widget.permissionController
                                                  .checkboxValue.value;
                                          widget.controller!.toggle(value
                                              ? SwitchState.on
                                              : SwitchState.off);
                                        })
                                  ],
                                ),
                                SizedBox(
                                    // width: 150,
                                    child: Button(
                                  labelText: 'Set Permission',
                                  onPressed: widget.changeController!.value &&
                                          widget.permissionController
                                                      .changeDetected[
                                                  widget.tileIndex]
                                              [widget.titleValue]
                                      ? () {
                                          widget.onSetPermission!(
                                              widget.titleValue);
                                        }
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
