import 'package:flutter/material.dart';

import '../../utils/table.dart';
import 'body-widget.dart';
import 'custom-expansion-tile.dart';

class AnimatedCardTile extends StatefulWidget {
  const AnimatedCardTile({
    Key? key,
    required this.headTitle,
    required this.dataList,
    required this.titleKey,
    required this.onDelete,
    required this.actionButton,
  }) : super(key: key);

  final HeadTitle headTitle;
  final List<dynamic> dataList;
  final String titleKey;
  final List<ActionButtonItem>? actionButton;
  final Future<bool> Function(Map<String, dynamic>, int)? onDelete;

  @override
  _AnimatedCardTileState createState() => _AnimatedCardTileState();
}

class _AnimatedCardTileState extends State<AnimatedCardTile> {
  int selectedIndex = -1;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomExpansionTile(
          // activeElement: 5,
          onDelete: () {
            return widget.onDelete!(widget.dataList[index], index);
          },
          selectedData: widget.dataList[index],
          actionButton: widget.actionButton,
          bodyWidget: List.generate(
            widget.headTitle.headTileItems!.length,
            (columnIndex) => BodyWidget(
              columnName:
                  widget.headTitle.headTileItems![columnIndex].titleName!,
              columnValue: widget.dataList[index]
                  [widget.headTitle.headTileItems![columnIndex].titleKey],
            ),
          ),
          titleValue: widget.dataList[index][widget.titleKey],
        );
      },
    );
  }
}
