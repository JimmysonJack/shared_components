// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'tabs.dart';

/// Tab bar
class TabsBar extends StatefulWidget {
  TabsBar({Key? key, required this.tabs, this.selectedIndex = 0})
      : super(key: key);
  final List<Tabs> tabs;
  int selectedIndex;
  Tabs? selectedTab;

  @override
  State<TabsBar> createState() => _TabsBarState();
}

class _TabsBarState extends State<TabsBar> {
  @override
  void initState() {
    if (widget.selectedIndex > widget.tabs.length - 1) {
      widget.selectedTab = widget.tabs[0];
    } else {
      widget.selectedTab = widget.tabs[widget.selectedIndex];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double appBarSize = AppBar().preferredSize.height;
    BorderSide borderSide =
        BorderSide(color: Theme.of(context).primaryColor, width: 1);
    BorderSide emptyBorder =
        const BorderSide(color: Colors.transparent, width: 0);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          SizedBox(
            height: appBarSize * 0.7,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                widget.tabs.length,
                (index) => InkWell(
                  onTap: () {
                    setState(() {
                      widget.selectedTab = widget.tabs[index];
                      widget.selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: widget.selectedIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        border: Border(
                            top: borderSide,
                            left: borderSide,
                            right:
                                widget.tabs.elementAt(widget.tabs.length - 1) ==
                                        widget.tabs.elementAt(index)
                                    ? borderSide
                                    : emptyBorder)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Text(
                      widget.tabs.elementAt(index).title,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                          color: widget.selectedIndex == index
                              ? Theme.of(context).cardColor
                              : Theme.of(context).hintColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 12,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border(top: borderSide)),
                child: widget.selectedTab?.page,
              ))
        ],
      ),
    ));
  }
}
