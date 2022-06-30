import 'package:flutter/material.dart';
import 'package:shared_component/src/utils/table.dart';
import '../../shared_component.dart';

class DataSourceTable<T> extends StatefulWidget {
  const DataSourceTable(
      {Key? key,
      this.buttonActivities,
      this.onDeleteLoader = false,
      required this.title,
      required this.serialNumberTitle,
      this.actionTitle,
      required this.heardTileItems,
      this.onPageSize,
      this.deleteData,
      this.actionButton,
      this.onDelete,
      required this.paginatePage,
      required this.dataList})
      : super(key: key);
  final List<ButtonActivities>? buttonActivities;
  final String title;
  final String serialNumberTitle;
  final String? actionTitle;
  final List<HeardTitleItem> heardTileItems;
  final Function(dynamic value)? onPageSize;
  final Function(dynamic value)? onDelete;
  final bool? deleteData;
  final List<ActionButtonItem<T>>? actionButton;
  final PaginatePage paginatePage;
  final List<Map<String,dynamic>> dataList;
  final bool onDeleteLoader;

  @override
  _DataSourceTableState<T> createState() => _DataSourceTableState<T>();
}

class _DataSourceTableState<T> extends State<DataSourceTable<T>> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left:size.width / 70,right: size.width / 70,bottom: size.width / 70),
        child: Column(
          children: <Widget>[
            ///SEARCH FIELD
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: size.width / 5,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                  ),
                ),
              ),
            ),

            ///DATA TABLE
            Expanded(
              child: GCard(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width / 45,
                        child: Container(
                          color: Theme.of(context).hoverColor,
                          height: size.height / 20,
                          padding: const EdgeInsets.only(left: 10),
                          width: size.width,
                          child: Row(
                            children: [
                              Text(widget.title.replaceAll('ComponentPage', '').toUpperCase(),style: Theme.of(context).textTheme.button),
                              Expanded(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: List.generate(widget.buttonActivities == null ? 0 : widget.buttonActivities!.length, (index) => Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Tooltip(
                                    message: widget.buttonActivities![index].toolTip ?? '',
                                    child: InkWell(
                                      onTap: widget.buttonActivities![index].onTap,
                                      child: widget.buttonActivities![index].icon ?? const SizedBox(),
                                    ),
                                  ),
                                )),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TableCustom<T>(
                          onDeleteLoader: widget.onDeleteLoader,
                          headTitles: HeardTitle(
                              serialNumberTitle: widget.serialNumberTitle,
                              actionTitle: widget.actionTitle,
                              heardTileItems: widget.heardTileItems
                          ),
                          onPageSize: widget.onPageSize!,
                          deleteData: widget.deleteData!,
                          actionButton: widget.actionButton,
                          paginatePage: widget.paginatePage,
                          onDelete: widget.onDelete,
                          dataList: widget.dataList,),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonActivities {
  final Icon? icon;
  final Text? textName;
  final String? toolTip;
  final Function() onTap;

  ButtonActivities({this.toolTip,this.icon, this.textName, required this.onTap})
      : assert(icon == null || textName == null,'Can not use both icon and textName');
}