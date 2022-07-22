import 'package:flutter/material.dart';
import 'package:shared_component/src/utils/table.dart';
import '../../shared_component.dart';

class DataSourceTable<T> extends StatefulWidget {
  const DataSourceTable(
      {Key? key,
        this.tableColor,
      this.buttonActivities,
      this.onDeleteLoader = false,
      this.loadOnMoreButton = false,
      required this.title,
      required this.serialNumberTitle,
      this.actionTitle,
      required this.heardTileItems,
      this.onPageSize,
      this.deleteData,
      this.actionButton,
      this.onSearch,
      this.onDelete,
      this.noSearchResults = false,
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
  final Function(String value)? onSearch;
  final bool? deleteData;
  final List<ActionButtonItem<T>>? actionButton;
  final PaginatePage paginatePage;
  final List<Map<String,dynamic>> dataList;
  final bool onDeleteLoader;
  final Color? tableColor;
  final bool noSearchResults;
  final bool loadOnMoreButton;

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
            Expanded(
              child: GCard(
                color: widget.tableColor ?? Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
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
                                Expanded(
                                  ///Search field
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        border: InputBorder.none,
                                        hintText: 'Search',
                                        // fillColor: Theme.of(context).cardColor,
                                        // filled: true
                                      ),
                                      onChanged: (value){
                                        if(widget.onSearch != null) widget.onSearch!(value);
                                      },
                                    )),
                                ///activities buttons
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ...List.generate(widget.buttonActivities == null ? 0 : widget.buttonActivities!.length, (index) => Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Tooltip(
                                          message: widget.buttonActivities![index].toolTip ?? '',
                                          child: InkWell(
                                            onTap: widget.buttonActivities![index].onTap,
                                            child: widget.buttonActivities![index].icon ?? widget.buttonActivities![index].textName,
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: !widget.noSearchResults ? TableCustom<T>(
                            onDeleteLoader: widget.onDeleteLoader,
                            loadOnMoreButton: widget.loadOnMoreButton,
                            color: widget.tableColor,
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
                            dataList: widget.dataList,): Center(
                            child: GErrorMessage(
                              icon: SvgPicture.asset(
                                'assets/empty.svg',
                                package: 'shared_component',
                                width: (size.width / 4) * 0.2,
                                height: (size.width / 4) * 0.2,
                                // color: Theme.of(context).errorColor,
                              ),
                              title: 'Sorry! No Data Found',
                              subtitle: 'Consider changing the keywords',

                            ),
                          ),
                        ),
                      ],
                    ),
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