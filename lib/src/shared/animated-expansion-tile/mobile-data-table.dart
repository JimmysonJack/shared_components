import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

import 'animated-card-tile.dart';

class MobileDataTable extends StatelessWidget {
  const MobileDataTable(
      {super.key,
      required this.dataList,
      required this.headTitle,
      required this.actionButton,
      required this.onDelete,
      required this.primaryAction,
      required this.titleKey});
  final List<dynamic> dataList;
  final HeadTitle headTitle;
  final String titleKey;
  final List<ActionButtonItem>? actionButton;
  final Future<bool> Function(Map<String, dynamic>, int)? onDelete;
  final PrimaryAction? primaryAction;

  @override
  Widget build(BuildContext context) {
    return AnimatedCardTile(
      primaryAction: primaryAction,
      titleKey: titleKey,
      dataList: dataList,
      headTitle: headTitle,
      onDelete: onDelete,
      actionButton: actionButton,
    );
  }
}
