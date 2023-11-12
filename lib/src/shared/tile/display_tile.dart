import 'package:flutter/material.dart';
import 'package:shaky_animated_listview/scroll_animator.dart';

import 'container_tile.dart';

class DisplayTile extends StatelessWidget {
  final List<ContainerTile> tilesList;
  const DisplayTile({super.key, required this.tilesList});
  // final controller = Get.put(SearchTileController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Center(
            child: Wrap(
          direction: Axis.horizontal,
          runSpacing: 13,
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          children: tilesList.map((e) => GridAnimatorWidget(child: e)).toList(),
        )),
      ),
    );
  }
}
