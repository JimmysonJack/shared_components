import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'search-controller.dart';

class ContainerTile extends StatefulWidget {
  final TileFields fields;
  final Color iconColor;
  List<Color>? gradientColorsList;
  Color? titalColor;
  Color? tileColor;
  final bool showGradient;

  ContainerTile(
      {super.key,
      required this.fields,
      this.tileColor,
      this.iconColor = Colors.black12,
      this.gradientColorsList,
      this.titalColor,
      this.showGradient = false}) {
    gradientColorsList ??= [
      Theme.of(Get.context!).secondaryHeaderColor,
      Theme.of(Get.context!).primaryColor
    ];
    titalColor ??= Theme.of(Get.context!).textTheme.bodyMedium?.color;
  }
  @override
  _ContainerTileState createState() => _ContainerTileState();
}

class _ContainerTileState extends State<ContainerTile> {
  bool isHovered = false;
  double minWidth = 375;
  Size screenSize = SizeConfig.fullScreen;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: isHovered ? 1.04 : 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: SearchTileController()
                .sizeCalc(
                    max: 300,
                    min: (screenSize.width / 2 - 30),
                    minWidthScreenSize: screenSize.width)
                .width,
            height: SearchTileController()
                .sizeCalc(
                    max: 150, min: 105, minWidthScreenSize: screenSize.width)
                .width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.tileColor ?? Colors.white,
              gradient: widget.showGradient
                  ? LinearGradient(colors: [
                      widget.gradientColorsList![0].withOpacity(0.3),
                      widget.gradientColorsList![1].withOpacity(0.7)
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onHover: (_) {
                  setState(() {
                    isHovered = _;
                  });
                },
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Modular.to.navigate(widget.fields.url);
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.fields.icon,
                      size: SearchTileController()
                          .sizeCalc(
                              max: 60, min: 40, minWidthScreenSize: minWidth)
                          .width,
                      color: widget.iconColor,
                    ),
                    const SizedBox(height: 10),
                    GText(
                      widget.fields.title,
                      fontWeight: FontWeight.bold,
                      color: widget.titalColor,
                      fontSize: SearchTileController()
                          .sizeCalc(
                              max: 20, min: 13, minWidthScreenSize: minWidth)
                          .width,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
