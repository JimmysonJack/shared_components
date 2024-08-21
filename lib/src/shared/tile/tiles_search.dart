// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/src/shared/layout/layout.dart';

import '../../models/user_model.dart';
import '../../utils/size_config.dart';
import '../nothing_found.dart';
import 'display_tile.dart';
import 'search_controller.dart';
import 'search_field.dart';

class TilesSearch extends StatefulWidget {
  final List<TileFields> tileFields;
  final List<Color>? gradientColors;
  final Color? iconColor;
  final Color? titleColor;
  final Color? tileColor;
  final bool? showGradient;
  const TilesSearch(
      {super.key,
      required this.tileFields,
      this.gradientColors,
      this.iconColor,
      this.titleColor,
      this.tileColor,
      this.showGradient});

  @override
  State<TilesSearch> createState() => _TilesSearchState();
}

class _TilesSearchState extends State<TilesSearch> {
  double fullSizeWidth = SizeConfig.fullScreen.width;

  double fullSizeHeight = SizeConfig.fullScreen.height;

  final searchTileController = Get.put(SearchTileController());

  @override
  void initState() {
    searchTileController.onSearchTiles(
        widget.tileFields,
        widget.gradientColors,
        widget.iconColor,
        widget.showGradient,
        widget.tileColor,
        widget.titleColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = context.layout.value(
        xs: fullSizeWidth, sm: fullSizeWidth * 0.5, md: fullSizeWidth * 0.4);
    return Scaffold(
      // backgroundColor: Colors.black54,
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchField(
                        onTap: () {
                          searchTileController.searchinputs.clear();
                          searchTileController.searchData(
                              widget.tileFields,
                              widget.gradientColors,
                              widget.iconColor,
                              widget.showGradient,
                              widget.tileColor,
                              widget.titleColor);
                        },
                        searchInput: searchTileController.searching.value,
                        controller: searchTileController.searchinputs,
                        width: width,
                        onChange: (value) {
                          searchTileController.searchData(
                              widget.tileFields,
                              widget.gradientColors,
                              widget.iconColor,
                              widget.showGradient,
                              widget.tileColor,
                              widget.titleColor);
                        }),
                    Expanded(
                        child: searchTileController.tileList.value.isEmpty
                            ? const NothingFound()
                            : DisplayTile(
                                tilesList:
                                    searchTileController.tileList.value)),
                  ]))),
    );
  }
}
