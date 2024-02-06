import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_component/src/utils/filter.dart';
import 'package:shared_component/src/utils/g_ui/g_card.dart';
import 'package:shared_component/src/utils/g_ui/g_error_message.dart';
import '../../shared_component.dart';

class DataSourceTable<T> extends StatefulWidget {
  const DataSourceTable(
      {Key? key,
      this.tableColor,
      this.buttonActivities,
      this.loadingOnUpdateData = false,
      required this.title,
      required this.serialNumberTitle,
      this.actionTitle,
      required this.headTileItems,
      this.onPageSize,
      this.deleteData,
      this.actionButton,
      this.onSearch,
      this.onDelete,
      this.onEmptySearch,
      this.noSearchResults = false,
      required this.paginatePage,
      required this.currentPageSize,
      this.filter,
      this.primaryAction,
      required this.dataList})
      : super(key: key);
  final List<ButtonActivities>? buttonActivities;
  final String title;
  final String serialNumberTitle;
  final String? actionTitle;
  final List<HeadTitleItem> headTileItems;
  final Function(dynamic value)? onPageSize;
  final Function(Map<String, dynamic> value)? onDelete;
  final Function(String value)? onSearch;
  final Function()? onEmptySearch;
  final bool? deleteData;
  final List<ActionButtonItem<T>>? actionButton;
  final PaginatePage paginatePage;
  final List<Map<String, dynamic>> dataList;
  final Color? tableColor;
  final bool noSearchResults;
  final int currentPageSize;
  final bool loadingOnUpdateData;
  final DataFilter? filter;
  final PrimaryAction? primaryAction;

  @override
  _DataSourceTableState<T> createState() => _DataSourceTableState<T>();
}

class _DataSourceTableState<T> extends State<DataSourceTable<T>> {
  TextEditingController searchController = TextEditingController();
  bool searchIsOn = false;
  @override
  void initState() {
    // console('this is the data list...............${widget.dataList}');
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width / 70,
            right: size.width / 70,
            bottom: size.width / 70),
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
                          // height: size.width / 45,
                          child: Container(
                            color: Theme.of(context).hoverColor,
                            // height: size.height / 15,
                            // padding: const EdgeInsets.only(left: 10),
                            width: size.width,
                            child: Row(
                              children: [
                                Expanded(

                                    ///Search field
                                    child: TextFormField(
                                  cursorHeight: 20,
                                  cursorRadius: const Radius.circular(20),
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    filled: false,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: searchController.text.isEmpty
                                        ? null
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Tooltip(
                                              message: 'Clear Search',
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: const Icon(Icons.close),
                                                onTap: () {
                                                  setState(() {
                                                    searchController.clear();
                                                    if (searchIsOn &&
                                                        widget.onEmptySearch !=
                                                            null) {
                                                      searchIsOn = false;
                                                      widget.onEmptySearch!();
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    // fillColor: Theme.of(context).secondaryHeaderColor,
                                    // filled: true
                                  ),
                                  onFieldSubmitted: (value) {
                                    if (widget.onSearch != null) {
                                      searchIsOn = true;
                                      widget.onSearch!(value);
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                    if (value.isEmpty &&
                                        widget.onEmptySearch != null) {
                                      searchIsOn = false;
                                      widget.onEmptySearch!();
                                    }
                                  },
                                )),

                                ///activities buttons
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ...List.generate(
                                          widget.buttonActivities == null
                                              ? 0
                                              : widget.buttonActivities!.length,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Tooltip(
                                                  message: widget
                                                          .buttonActivities![
                                                              index]
                                                          .toolTip ??
                                                      '',
                                                  child: OutlinedButton(
                                                    onPressed: widget
                                                        .buttonActivities![
                                                            index]
                                                        .onTap,
                                                    child: widget
                                                            .buttonActivities![
                                                                index]
                                                            .textName ??
                                                        widget
                                                            .buttonActivities![
                                                                index]
                                                            .icon,
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
                          child: !widget.noSearchResults
                              ? TableCustom<T>(
                                  primaryAction: widget.primaryAction,
                                  loadingOnUpdateData:
                                      widget.loadingOnUpdateData,
                                  currentPageSize: widget.currentPageSize,
                                  color: widget.tableColor,
                                  headTitles: HeadTitle(
                                      serialNumberTitle:
                                          widget.serialNumberTitle,
                                      actionTitle: widget.actionTitle,
                                      headTileItems: widget.headTileItems),
                                  onPageSize: widget.onPageSize,
                                  deleteData: widget.deleteData ?? false,
                                  actionButton: widget.actionButton,
                                  paginatePage: widget.paginatePage,
                                  onDelete: widget.onDelete,
                                  dataList: DataFilter.filter(
                                      widget.dataList,
                                      widget.filter?.filterString,
                                      widget.filter?.filterField,
                                      widget.filter?.equal),
                                )
                              : Center(
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

  ButtonActivities(
      {required this.toolTip, this.icon, this.textName, required this.onTap});
  // : assert(icon == null || textName == null,'Can not use both icon and textName');
}
