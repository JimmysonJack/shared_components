import 'package:flutter/material.dart';

import '../../../themes/theme.dart';
import 'dash_tile_data.dart';

class DashTile extends StatefulWidget {
  const DashTile(
      {super.key,
      required this.icon,
      required this.tileName,
      this.dashTileData,
      this.onTap,
      required this.count});
  final IconData? icon;
  final String? tileName;
  final String? count;
  final DashTileData? dashTileData;
  final Function()? onTap;

  @override
  State<DashTile> createState() => _DashTileState();
}

class _DashTileState extends State<DashTile> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(builder: (context, constraintSize) {
        return Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        stops: [
                          0.5,
                          1
                        ],
                        colors: [
                          Color.fromARGB(0, 158, 158, 158),
                          Color.fromARGB(125, 220, 221, 209)
                        ]),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(4))),
                child: Stack(
                  children: [
                    ClipRect(
                      child: Align(
                        widthFactor: 0.5,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          widget.icon,
                          size: constraintSize.maxHeight * 0.8,
                          color: const Color.fromARGB(37, 158, 158, 158),
                        ),
                      ),
                    ),
                    if (widget.dashTileData == null)
                      Center(
                        child: Text(
                          widget.count ?? '0',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (widget.dashTileData != null)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.dashTileData?.countOne ?? '0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  color:
                                      const Color.fromARGB(49, 158, 158, 158),
                                  height: constraintSize.maxHeight * 0.1,
                                  child: Center(
                                      child: Text(
                                    widget.dashTileData?.nameOne ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontSize:
                                              constraintSize.maxHeight * 0.06,
                                        ),
                                  )),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.dashTileData?.countTwo ?? '0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  color:
                                      const Color.fromARGB(49, 158, 158, 158),
                                  height: constraintSize.maxHeight * 0.1,
                                  child: Center(
                                      child: Text(
                                    widget.dashTileData?.nameTwo ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontSize:
                                              constraintSize.maxHeight * 0.06,
                                        ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(4)),
              onTap: widget.onTap,
              onHover: (value) {
                setState(() {
                  hovered = !hovered;
                });
              },
              child: SizedBox(
                height: constraintSize.maxHeight * 0.2,
                child: Center(
                    child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: !hovered
                            ? -constraintSize.maxWidth
                            : constraintSize.maxWidth * 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: constraintSize.maxWidth,
                            height: constraintSize.maxHeight,
                            alignment: Alignment.center,
                            child: Text(
                              'View Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: ThemeController.getInstance()
                                          .darkMode(
                                              darkColor: Colors.blue,
                                              lightColor: Theme.of(context)
                                                  .primaryColor)),
                            ),
                          ),
                        )),
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        right: hovered
                            ? -constraintSize.maxWidth
                            : constraintSize.maxWidth * 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: constraintSize.maxWidth,
                            height: constraintSize.maxHeight,
                            alignment: Alignment.center,
                            child: Text(
                              widget.tileName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: ThemeController.getInstance()
                                          .darkMode(
                                              darkColor: Colors.white38,
                                              lightColor: Colors.black38)),
                            ),
                          ),
                        )),
                  ],
                )),
              ),
            )
          ],
        );
      }),
    );
  }
}
