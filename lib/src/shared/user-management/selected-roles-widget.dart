import 'package:flutter/material.dart';

import '../../themes/theme.dart';
import '../../utils/size_config.dart';

class SelectedRoleWidget extends StatefulWidget {
  const SelectedRoleWidget(
      {super.key,
      required this.selectedList,
      required this.onDelete,
      required this.animate});
  final List<Map<String, dynamic>>? selectedList;
  final void Function(Map<String, dynamic> data) onDelete;
  final Map<String, dynamic> animate;

  @override
  State<SelectedRoleWidget> createState() => _SelectedRoleWidgetState();
}

class _SelectedRoleWidgetState extends State<SelectedRoleWidget> {
  bool onHover = false;
  double size = 0;
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        child: SizedBox(
          height: SizeConfig.fullScreen.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: LayoutBuilder(builder: (context, constraint) {
              return widget.selectedList!.isEmpty
                  ? Center(
                      child: Text(
                        'Role Not Set Yet',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(
                            widget.selectedList!.length,
                            (tileIndex) => TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 500),
                                tween: Tween<double>(
                                    begin: 0.0,
                                    end: widget.selectedList?[tileIndex] == null
                                        ? 0.0
                                        : 1.0),
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: MouseRegion(
                                      onExit: (value) {
                                        setState(() {
                                          onHover = false;
                                          selectedIndex = tileIndex;
                                        });
                                      },
                                      onHover: (value) {
                                        setState(() {
                                          onHover = true;
                                          selectedIndex = tileIndex;
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: (constraint.maxWidth * 0.5) - 5,
                                        color: ThemeController.getInstance()
                                            .darkMode(
                                                darkColor: Colors.white30,
                                                lightColor: Colors.black26),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn,
                                              child: Text(
                                                widget.selectedList![tileIndex]
                                                    ['name'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontSize: selectedIndex ==
                                                                    tileIndex &&
                                                                onHover
                                                            ? 7
                                                            : null),
                                              ),
                                            ),
                                            AnimatedContainer(
                                                alignment: Alignment.center,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                width: selectedIndex ==
                                                            tileIndex &&
                                                        onHover
                                                    ? 40
                                                    : 0,
                                                child: TweenAnimationBuilder<
                                                    double>(
                                                  tween: Tween<double>(
                                                      begin: 0.0,
                                                      end: selectedIndex ==
                                                                  tileIndex &&
                                                              onHover
                                                          ? 1.0
                                                          : 0.0),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  builder:
                                                      (context, scale, child) {
                                                    return Transform.scale(
                                                      scale: scale,
                                                      child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          onTap: () => widget
                                                              .onDelete(widget
                                                                      .selectedList![
                                                                  tileIndex]),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                                Icons.clear),
                                                          )),
                                                    );
                                                  },
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
