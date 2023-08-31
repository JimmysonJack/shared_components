import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import '../popUpMenu/custom_pop_up_menu.dart';

class TableCustom<T> extends StatefulWidget {
  const TableCustom(
      {Key? key,
      this.loadingOnUpdateData = false,
      required this.currentPageSize,
      this.color,
      required this.dataList,
      this.onCreate,
      this.onDelete,
      required this.headTitles,
      this.deleteData = false,
      this.actionButton,
      this.paginatePage,
      this.primaryAction,
      required this.onPageSize})
      : super(key: key);
  final List<dynamic> dataList;
  final void Function(dynamic)? onCreate;
  final void Function(Map<String, dynamic>)? onDelete;
  final HeadTitle headTitles;
  final bool deleteData;
  final List<ActionButtonItem<T>>? actionButton;
  final PaginatePage? paginatePage;
  final void Function(dynamic)? onPageSize;
  final Color? color;
  final int currentPageSize;
  final bool loadingOnUpdateData;
  final PrimaryAction? primaryAction;

  @override
  _TableCustomState<T> createState() => _TableCustomState<T>();
}

class _TableCustomState<T> extends State<TableCustom<T>> {
  int pressedIndex = -10;
  int loadingIndex = -0;
  bool hover = false;
  int hoverIndex = -1;
  final dataTableController = Get.put(DataTableController());

  @override
  void initState() {
    widget.actionButton
        ?.removeWhere((element) => element.permissionGranted == false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (SizeConfig.fullScreen.width <= 820) {
      return MobileDataTable(
          primaryAction: widget.primaryAction,
          dataList: widget.dataList,
          headTitle: widget.headTitles,
          onDelete: !widget.deleteData
              ? null
              : (data, index) async {
                  return await deleteConfirm(index);
                },
          actionButton: widget.actionButton,
          titleKey: 'name');
    }
    return Column(
      children: [
        ///TITLE TILE
        ListTile(
          tileColor: Colors.black.withOpacity(0.3),
          title: Card(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              children: [
                if (widget.headTitles.serialNumberTitle != null)
                  Container(
                    width: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.headTitles.serialNumberTitle!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                ...List.generate(
                    widget.headTitles.headTileItems!.length,
                    (x) => widget.headTitles.headTileItems?[x].columnSize !=
                            null
                        ? Container(
                            width:
                                widget.headTitles.headTileItems?[x].columnSize,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: widget.headTitles.headTileItems?[x]
                                        .alignment !=
                                    null
                                ? widget.headTitles.headTileItems![x].alignment
                                : Alignment.centerLeft,
                            child: Text(
                              widget.headTitles.headTileItems![x].titleName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )
                        : Expanded(
                            child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: widget.headTitles.headTileItems?[x]
                                        .alignment !=
                                    null
                                ? widget.headTitles.headTileItems![x].alignment
                                : Alignment.centerLeft,
                            child: Text(
                              widget.headTitles.headTileItems![x].titleName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ))),
                if (widget.headTitles.actionTitle != null &&
                        widget.actionButton!.isNotEmpty ||
                    widget.deleteData ||
                    SettingsService.use.permissionCheck(
                        widget.primaryAction?.permissions ?? []))
                  Container(
                    width: 122,
                    alignment: Alignment.center,
                    child: Text(
                      widget.headTitles.actionTitle!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                if (widget.headTitles.actionTitle == null ||
                    widget.actionButton!.isEmpty && !widget.deleteData)
                  const SizedBox(width: 0),
              ],
            ),
          ),
        ),
        if (widget.loadingOnUpdateData) IndicateProgress.linear(),
        Expanded(
          child: ListView.builder(
              // controller: ScrollController(),
              shrinkWrap: true,
              itemCount: widget.dataList.length,
              itemBuilder: (_, index) {
                return Card(
                  // elevation:
                  //     hoverIndex == index ? _animationTween.value : 1,
                  color: widget.dataList.elementAt(index)?['hasError'] ?? false
                      ? Theme.of(context).colorScheme.error.withOpacity(0.5)
                      : widget.color ?? Theme.of(context).primaryColor,
                  child: ListTile(
                    onTap: () {},
                    dense: true,
                    title: Row(
                      children: [
                        if (widget.headTitles.serialNumberTitle != null)
                          SizedBox(
                            width: 50,
                            child: Text(
                              // '${(index + 1) + ((widget.paginatePage!.currentPage - 1) * widget.paginatePage!.pageSize)}',
                              '${(index + 1)}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ...List.generate(
                            widget.headTitles.headTileItems!.length,
                            (i) => widget.headTitles.headTileItems?[i]
                                        .columnSize !=
                                    null
                                ? Container(
                                    width: widget.headTitles.headTileItems?[i]
                                        .columnSize,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    alignment: widget.headTitles
                                                .headTileItems?[i].alignment !=
                                            null
                                        ? widget.headTitles.headTileItems![i]
                                            .alignment
                                        : Alignment.centerLeft,

                                    ///SUB-OBJECT CAN BE ADDED HERE
                                    child: widget.headTitles.headTileItems?[i]
                                                .objectKeyField !=
                                            null
                                        ? Text(
                                            widget.dataList[index][widget
                                                        .headTitles
                                                        .headTileItems?[i]
                                                        .titleKey] ==
                                                    null
                                                ? '---'
                                                : formatter(
                                                    widget
                                                        .headTitles
                                                        .headTileItems![i]
                                                        .isMoney!,
                                                    widget
                                                        .headTitles
                                                        .headTileItems?[i]
                                                        .dateFormat,
                                                    widget
                                                        .dataList[index][widget
                                                                .headTitles
                                                                .headTileItems?[i]
                                                                .titleKey][
                                                            widget
                                                                .headTitles
                                                                .headTileItems?[
                                                                    i]
                                                                .objectKeyField]
                                                        .toString()
                                                        .replaceAll('_', ' ')
                                                        .replaceAll(
                                                            'null', '---')),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                        : Text(
                                            formatter(
                                              widget.headTitles
                                                  .headTileItems![i].isMoney!,
                                              widget.headTitles
                                                  .headTileItems?[i].dateFormat,
                                              widget.dataList[index][widget
                                                      .headTitles
                                                      .headTileItems?[i]
                                                      .titleKey]
                                                  .toString()
                                                  .replaceAll('_', ' ')
                                                  .replaceAll('null', '---'),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                  )
                                : Expanded(
                                    child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    alignment: widget.headTitles
                                                .headTileItems?[i].alignment !=
                                            null
                                        ? widget.headTitles.headTileItems![i]
                                            .alignment
                                        : Alignment.centerLeft,
                                    child: widget.headTitles.headTileItems?[i]
                                                .objectKeyField !=
                                            null
                                        ? Text(
                                            widget.dataList[index][widget
                                                        .headTitles
                                                        .headTileItems?[i]
                                                        .titleKey] ==
                                                    null
                                                ? '---'
                                                : formatter(
                                                    widget
                                                        .headTitles
                                                        .headTileItems![i]
                                                        .isMoney!,
                                                    widget
                                                        .headTitles
                                                        .headTileItems?[i]
                                                        .dateFormat,
                                                    widget
                                                        .dataList[index][widget
                                                                .headTitles
                                                                .headTileItems?[i]
                                                                .titleKey][
                                                            widget
                                                                .headTitles
                                                                .headTileItems?[
                                                                    i]
                                                                .objectKeyField]
                                                        .toString()
                                                        .replaceAll('_', ' ')
                                                        .replaceAll(
                                                            'null', '---')),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                        : Text(
                                            formatter(
                                                widget.headTitles
                                                    .headTileItems![i].isMoney!,
                                                widget
                                                    .headTitles
                                                    .headTileItems?[i]
                                                    .dateFormat,
                                                widget.dataList[index][widget
                                                        .headTitles
                                                        .headTileItems?[i]
                                                        .titleKey]
                                                    .toString()
                                                    .replaceAll('_', ' ')
                                                    .replaceAll('null', '---')),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                  ))),
                        if (widget.headTitles.actionTitle!.isNotEmpty &&
                                widget.actionButton!.isNotEmpty ||
                            SettingsService.use.permissionCheck(
                                widget.primaryAction?.permissions ?? []))
                          SizedBox(
                            width: 122,
                            height: 30,
                            child: Row(
                              mainAxisAlignment:
                                  widget.actionButton!.isNotEmpty &&
                                          widget.deleteData
                                      ? MainAxisAlignment.spaceAround
                                      : MainAxisAlignment.center,
                              children: [
                                if (widget.actionButton!.isNotEmpty ||
                                    SettingsService.use.permissionCheck(
                                        widget.primaryAction?.permissions ??
                                            []))
                                  Obx(() {
                                    final bool loading =
                                        dataTableController.onLoadMore.value;
                                    return loading && loadingIndex == index
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                backgroundColor: Colors.black12,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          )
                                        : SettingsService.use.permissionCheck(
                                                widget.primaryAction
                                                        ?.permissions ??
                                                    [])
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  widget.primaryAction
                                                      ?.onPressed(widget
                                                          .dataList[index]);
                                                },
                                                child: Text(
                                                  widget.primaryAction
                                                          ?.buttonName ??
                                                      '',
                                                  style: TextStyle(
                                                      color: ThemeController
                                                              .getInstance()
                                                          .darkMode(
                                                              darkColor: Colors
                                                                  .white54,
                                                              lightColor: Theme
                                                                      .of(context)
                                                                  .primaryColor)),
                                                ))
                                            : QudsPopupButton(
                                                tooltip: 'More',
                                                items: List.generate(
                                                    widget.actionButton!.length,
                                                    (pressIndex) =>
                                                        QudsPopupMenuItem(
                                                            leading: Icon(widget
                                                                .actionButton![
                                                                    pressIndex]
                                                                .icon),
                                                            title: Text(widget
                                                                .actionButton![
                                                                    pressIndex]
                                                                .name),
                                                            onPressed: () {
                                                              loadingIndex =
                                                                  index;
                                                              widget
                                                                  .actionButton![
                                                                      pressIndex]
                                                                  .onPressed(widget
                                                                          .dataList[
                                                                      index]);
                                                            })),
                                                // widthSize: 200,
                                                child: FloatingActionButton(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.7),
                                                  mini: true,
                                                  elevation: 10,
                                                  onPressed: null,
                                                  child: Icon(
                                                    Icons.more_vert_sharp,
                                                    size: 15,
                                                    color: ThemeController
                                                            .getInstance()
                                                        .darkMode(
                                                            darkColor:
                                                                Colors.white,
                                                            lightColor:
                                                                Colors.white54),
                                                  ),
                                                ),
                                              );
                                  }),
                                if (widget.actionButton!.isNotEmpty ||
                                    widget.primaryAction != null)
                                  Container(
                                    width: 5,
                                  ),
                                Obx(() {
                                  final bool loading =
                                      dataTableController.onDeleteLoad.value;
                                  return widget.deleteData == true
                                      ? loading && pressedIndex == index
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5.0),
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1.5,
                                                  backgroundColor:
                                                      Colors.black12,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : FloatingActionButton(
                                              elevation: 10,
                                              mini: true,
                                              backgroundColor: Colors.red,
                                              tooltip: 'Delete',
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 17,
                                              ),
                                              onPressed: () {
                                                deleteConfirm(index);
                                              },
                                            )
                                      : Container();
                                })
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
        ),

        if (widget.paginatePage != null)
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GText(
                            widget.onPageSize == null
                                ? 'Number Of Elements'
                                : 'Page Size',
                            color: ThemeController.getInstance().darkMode(
                                darkColor: Colors.white30,
                                lightColor: Colors.black38)),
                      ),
                      Container(
                        width: 10,
                      ),
                      if (widget.onPageSize != null)
                        DropdownButton(
                            isDense: true,
                            underline: Container(),
                            value: widget.currentPageSize,
                            items: const [
                              DropdownMenuItem(value: 10, child: Text('10')),
                              DropdownMenuItem(value: 20, child: Text('20')),
                              DropdownMenuItem(value: 50, child: Text('50')),
                              DropdownMenuItem(value: 100, child: Text('100')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                // widget.currentPageSize = int.parse(value.toString());
                                if (widget.onPageSize != null) {
                                  widget.onPageSize!(value);
                                }
                              });
                            }),
                      if (widget.onPageSize == null)
                        GText(
                          widget.currentPageSize.toString(),
                          color: ThemeController.getInstance().darkMode(
                              darkColor: Colors.white30,
                              lightColor: Colors.black38),
                        )
                    ],
                  ),
                )),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerRight,
                    child: widget.paginatePage,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  deleteConfirm(index) {
    return NotificationService.confirmWarn(
      context: NavigationService.get.currentContext!,
      buttonColor: Theme.of(context).colorScheme.error,
      cancelBtnText: 'Cancel',
      confirmBtnText: 'Delete',
      title: 'Deleting Record...',
      content: 'Are You Sure?',
      showCancelBtn: true,
      onConfirmBtnTap: () {
        pressedIndex = index;
        widget.onDelete!(widget.dataList[index]);
        Navigator.pop(NavigationService.get.currentContext!, true);
      },
      // onCancelBtnTap: () {
      //   // Navigator.pop(context, true);
      //   return true;
      // }
    );
  }
}

///PAGINATE CLASS
class PaginatePage extends StatefulWidget {
  const PaginatePage(
      {Key? key,
      this.currentPage = 0,
      this.totalPages = 0,
      this.pageSize = 0,
      this.onNavigateToPage,
      this.currentPageColors = Colors.teal,
      this.nextPage = 0})
      : super(key: key);
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int nextPage;
  final Color currentPageColors;
  final Function(PaginatePage paginatePage)? onNavigateToPage;

  @override
  _PaginatePageState createState() => _PaginatePageState();
}

class _PaginatePageState extends State<PaginatePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ///PREVIOUS PAGES
        if (widget.currentPage > 2)
          FloatingActionButton(
              backgroundColor: Theme.of(context).canvasColor,
              tooltip: 'Total Previous Pages',
              elevation: 7,
              mini: true,
              child: Text(
                (1).toString(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: ThemeController.getInstance().darkMode(
                        darkColor: Colors.white, lightColor: Colors.white)),
              ),
              onPressed: () {
                setState(() {
                  widget.onNavigateToPage!(const PaginatePage(
                    nextPage: 1,
                  ));
                });
              }),

        ///CONTINUES DOTS
        if (widget.currentPage > 2)
          SizedBox(
            width: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Container()),
                Text(
                  '.....',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: ThemeController.getInstance().darkMode(
                          darkColor: Colors.white, lightColor: Colors.white)),
                )
              ],
            ),
          ),

        ///PREVIOUS PAGE
        if (widget.currentPage > 1)
          FloatingActionButton(
              backgroundColor: Theme.of(context).canvasColor,
              tooltip: 'Previous Page',
              elevation: 7,
              mini: true,
              child: Text((widget.currentPage - 1).toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: ThemeController.getInstance().darkMode(
                          darkColor: Colors.white, lightColor: Colors.white))),
              onPressed: () {
                widget.onNavigateToPage!(PaginatePage(
                  nextPage: widget.currentPage - 1,
                ));
              }),

        Container(
          width: 5,
        ),

        ///CURRENT PAGE
        FloatingActionButton(
            tooltip: 'Current Page',
            backgroundColor: widget.currentPageColors,
            elevation: 7,
            mini: true,
            child: Text(
              (widget.currentPage).toString(),
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  color: ThemeController.getInstance().darkMode(
                      darkColor: Colors.white, lightColor: Colors.white)),
            ),
            onPressed: () {}),

        Container(
          width: 5,
        ),

        ///NEXT PAGE
        if (widget.totalPages > widget.currentPage)
          FloatingActionButton(
              backgroundColor: Theme.of(context).canvasColor,
              tooltip: 'Next Page',
              elevation: 7,
              mini: true,
              child: Text(
                (widget.currentPage + 1).toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onPressed: () {
                setState(() {
                  widget.onNavigateToPage!(PaginatePage(
                    nextPage: widget.currentPage + 1,
                  ));
                });
              }),

        ///CONTINUES DOTS
        if (widget.totalPages > (widget.currentPage + 1))
          SizedBox(
            width: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Container()),
                Text(
                  '.....',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),

        ///TOTAL PAGES
        if (widget.totalPages > (widget.currentPage + 1))
          FloatingActionButton(
              backgroundColor: Theme.of(context).canvasColor,
              tooltip: 'Total Pages',
              elevation: 7,
              mini: true,
              child: Text(
                (widget.totalPages).toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onPressed: () {
                setState(() {
                  widget.onNavigateToPage!(PaginatePage(
                    nextPage: widget.totalPages,
                  ));
                });
              }),
      ],
    );
  }
}

class HeadTitle {
  final String? serialNumberTitle;
  final String? actionTitle;
  final List<HeadTitleItem>? headTileItems;

  HeadTitle({this.serialNumberTitle, this.actionTitle, this.headTileItems});
}

class HeadTitleItem {
  final String? titleKey;
  final String? titleName;
  final String? objectKeyField;
  final double? columnSize;
  final Alignment? alignment;
  final bool? isMoney;
  final DateTimeFormat? dateFormat;

  HeadTitleItem(
      {this.titleKey,
      this.titleName,
      this.objectKeyField,
      this.columnSize,
      this.isMoney = false,
      this.dateFormat,
      this.alignment});
}

enum DateTimeFormat { short, medium }

class ActionButtonItem<T> {
  final IconData icon;
  final String name;
  final Function(T) onPressed;
  final bool permissionGranted;
  final bool isDate;

  ActionButtonItem(
      {this.isDate = false,
      this.permissionGranted = true,
      required this.icon,
      required this.name,
      required this.onPressed});
}

class PagingValues {
  static PagingValues? _instance;

  int? _pageSize;

  static PagingValues getInstance() {
    _instance ??= PagingValues();
    return _instance!;
  }

  clearInstance() {
    _instance = null;
  }

  int getPageSize() => _pageSize ?? 10;

  setPageSize(value) => _pageSize = value;
}

class PrimaryAction {
  final String buttonName;
  final Function(dynamic) onPressed;
  final List<String> permissions;

  PrimaryAction(
      {required this.buttonName,
      required this.onPressed,
      required this.permissions});
}

class DataTableController extends GetxController {
  final onDeleteLoad = false.obs;
  final onLoadMore = false.obs;
  final rebuild = false.obs;
}

class RebuildToRefetch {
  static RebuildToRefetch? _instance;
  bool _refetchState = false;
  DataTableController controller = Get.put(DataTableController());

  static RebuildToRefetch instance() {
    _instance ??= RebuildToRefetch();
    return _instance!;
  }

  bool changeRefetchState(bool value) => _refetchState = value;

  bool getRefetchState() => _refetchState;

  refetch() {
    if (changeRefetchState(true)) {
      controller.rebuild.value = !controller.rebuild.value;
    }
  }
}

String formatter(bool isMoney, DateTimeFormat? format, String data) {
  if (!SettingsService.use.isEmptyOrNull(format)) {
    return SettingsService.use.dateFormat(format, data);
  } else if (isMoney) {
    return currencyFormatter(data);
  } else {
    return data;
  }
}
