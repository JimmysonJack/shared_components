
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_component/src/tabs_bar/tabs.dart';
import 'package:shared_component/src/tabs_bar/tabs_bar_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TabsBar extends StatefulWidget {
  const TabsBar({Key? key, required this.tabs}) : super(key: key);
  final List<Tabs> tabs;

  @override
  State<TabsBar> createState() => _TabsBarState();
}

class _TabsBarState extends State<TabsBar> {
  @override
  void initState() {
    TabsBarStore.getInstance().setTabs(widget.tabs);

    int selectedIndex = TabsBarStore.getInstance().tabsItems.indexWhere((element) => Modular.to.path.contains(element.url)) == -1
        ? 0
        : TabsBarStore.getInstance().tabsItems.indexWhere((secondElement) => Modular.to.path.contains(secondElement.url));

    // TabsBarStore.getInstance().onSelected(
    //     itemIndex: selectedIndex,
    //     url: TabsBarStore.getInstance().tabsItems[selectedIndex].url);
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double appBarSiz = AppBar().preferredSize.height;
    BorderSide borderSide = BorderSide(color: Theme.of(context).primaryColor,width: 1);
    BorderSide emptyBorder = const BorderSide(color: Colors.transparent,width: 0);
    return Observer(
      builder: (context) {
        return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: appBarSiz * 0.7,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(TabsBarStore.getInstance().tabsItems.length, (index) => InkWell(
                        onTap: (){
                          setState(() {
                            selectedIndex = index;
                            TabsBarStore.getInstance().onSelected(
                                itemIndex: selectedIndex,
                                url: TabsBarStore.getInstance().tabsItems[selectedIndex].url);
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          alignment: Alignment.center,
                          decoration:
                          BoxDecoration(
                              color: selectedIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
                              border: Border(top: borderSide, left: borderSide,right: TabsBarStore.getInstance().tabsItems.elementAt(TabsBarStore.getInstance().tabsItems.length -1) == TabsBarStore.getInstance().tabsItems.elementAt(index) ? borderSide : emptyBorder)),
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          child: Text(TabsBarStore.getInstance().tabsItems.elementAt(index).title,style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,color: selectedIndex == index ? Theme.of(context).cardColor : Theme.of(context).disabledColor),),
                        ),
                      ),),
                    ),
                  ),
                  Expanded(
                      flex: 12,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border(top: borderSide)
                        ),
                        child: const RouterOutlet(),
                      )
                  )
                ],
              ),
            )
        );
      }
    );
  }
}



