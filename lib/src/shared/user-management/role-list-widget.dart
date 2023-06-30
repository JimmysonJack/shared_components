import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'user-roles-controller.dart';

class RolesListWidget extends StatefulWidget {
  const RolesListWidget(
      {super.key,
      required this.roleList,
      required this.onSelected,
      required this.animate});
  final List<Map<String, dynamic>>? roleList;
  final void Function(Map<String, dynamic> data) onSelected;
  final Map<String, dynamic> animate;

  @override
  State<RolesListWidget> createState() => _RolesListWidgetState();
}

class _RolesListWidgetState extends State<RolesListWidget> {
  TextEditingController controller = TextEditingController();
  int selectedIndex = -1;
  UserRolesController userRolesController = Get.put(UserRolesController());

  // ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // scrollController.addListener(() {
    //   console(scrollController.position.pixels);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search',
                      // isDense: true,
                    ),
                  ),
                  userRolesController.loading.value
                      ? IndicateProgress.linear()
                      : Expanded(
                          child: widget.roleList!.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nothing Found',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                )
                              : ListView.builder(
                                  // controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: widget.roleList!.length,
                                  itemBuilder: (context, index) {
                                    return TweenAnimationBuilder<double>(
                                        onEnd: () {
                                          // setState(() {
                                          //   selectedIndex = 0;
                                          // });
                                        },
                                        duration:
                                            const Duration(milliseconds: 500),
                                        tween: Tween<double>(
                                            begin: 0.0,
                                            end: widget.roleList?[index] == null
                                                ? 0.0
                                                : 1.0),
                                        builder: (context, scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: Card(
                                              child: ListTile(
                                                onTap: () {
                                                  widget.onSelected(
                                                      widget.roleList?[index] ??
                                                          {});
                                                },
                                                title: Text(
                                                    widget.roleList?[index]
                                                            ['name'] ??
                                                        ''),
                                                subtitle: Text(
                                                    widget.roleList?[index]
                                                            ['descriprions'] ??
                                                        ''),
                                              ),
                                            ),
                                          );
                                        });
                                  }))
                ],
              ),
            ),
          ),
        ));
  }
}
