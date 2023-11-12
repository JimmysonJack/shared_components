import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

import 'container_tile.dart';

class SearchTileController extends GetxController {
  final searchinputs = TextEditingController();
  final searching = ''.obs;
  final tileList = <ContainerTile>[].obs;
  searchData(
      List<TileFields> fields,
      List<Color>? gradientColors,
      Color? iconColor,
      bool? showGradient,
      Color? tileColor,
      Color? titleColor) {
    searching.value = searchinputs.text;
    onSearchTiles(
        fields, gradientColors, iconColor, showGradient, tileColor, titleColor);
  }

  Size sizeCalc(
      {required double max,
      required double min,
      double? maxWidthScreenSize,
      double? minWidthScreenSize}) {
    return SettingsService.use.sizeByScreenWidth(
        max: max,
        min: min,
        maxWidthScreenSize: maxWidthScreenSize,
        minWidthScreenSize: minWidthScreenSize);
  }

  onSearchTiles(
      List<TileFields> fields,
      List<Color>? gradientColors,
      Color? iconColor,
      bool? showGradient,
      Color? tileColor,
      Color? titleColor) {
    if (searching.value.isEmpty) {
      tileList.value = fields
          .where((element) =>
              SettingsService.use.permissionCheck(element.permissions))
          .map((e) => ContainerTile(
                fields: e,
                gradientColorsList: gradientColors,
                iconColor: iconColor ?? Colors.black12,
                showGradient: showGradient ?? false,
                tileColor: tileColor,
                titalColor: titleColor,
              ))
          .toList();
      return;
    }

    var searchQuery = searching.value.toLowerCase();

    var newList = fields
        .where((element) => element.title.toLowerCase().contains(searchQuery))
        .toList();

    tileList.value = newList
        .where((element) =>
            SettingsService.use.permissionCheck(element.permissions))
        .map((e) => ContainerTile(
              fields: e,
              gradientColorsList: gradientColors,
              iconColor: iconColor ?? Colors.black12,
              showGradient: showGradient ?? false,
              tileColor: tileColor,
              titalColor: titleColor,
            ))
        .toList();
  }
}
