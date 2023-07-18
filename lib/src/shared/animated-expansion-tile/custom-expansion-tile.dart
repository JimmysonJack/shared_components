import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';


class CustomExpansionTile extends StatefulWidget {
  final List<Widget> bodyWidget;
  final int? activeElement;
  final String titleValue;
  final Map<String, dynamic> selectedData;
  final List<ActionButtonItem>? actionButton;
  final Future<bool> Function()? onDelete;

  const CustomExpansionTile(
      {super.key,
      required this.bodyWidget,
      this.activeElement,
      required this.selectedData,
      this.actionButton,
      required this.onDelete,
      required this.titleValue});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool loading = false;
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
                children: [
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ...widget.bodyWidget,
                  Obx(() => dataTableController.onLoadMore.value ||
                          dataTableController.onDeleteLoad.value
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IndicateProgress.linear(),
                                const GText('Loading...')
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ButtonBar(
                            children: [
                              if (widget.onDelete != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            if (await widget.onDelete!()) {}
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          )),
                                      const GText('Delete')
                                    ],
                                  ),
                                ),
                              ...List.generate(
                                  widget.actionButton!.length,
                                  (buttonIndex) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  widget.actionButton![
                                                          buttonIndex]
                                                      .onPressed(
                                                          widget.selectedData);
                                                },
                                                icon: Icon(widget
                                                    .actionButton![buttonIndex]
                                                    .icon)),
                                            GText(widget
                                                .actionButton![buttonIndex]
                                                .name)
                                          ],
                                        ),
                                      )),
                            ],
                          ),
                        )),
                ],
              )),
        ],
      ),
    );
  }
}
