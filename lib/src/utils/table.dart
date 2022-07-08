import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

import '../popUpMenu/custom_pop_up_menu.dart';



class TableCustom<T> extends StatefulWidget {
  const TableCustom({Key? key,this.color,required this.dataList,this.onCreate,this.onDelete, required this.headTitles, this.deleteData = false, this.actionButton, this.paginatePage, required this.onPageSize, this.onDeleteLoader = false}) : super(key: key);
  final List<dynamic> dataList;
  final void Function(dynamic)? onCreate;
  final void Function(String value)? onDelete;
  final HeardTitle headTitles;
  final bool deleteData;
  final List<ActionButtonItem<T>>? actionButton;
  final PaginatePage? paginatePage;
  final void Function(dynamic) onPageSize;
  final bool onDeleteLoader;
  final Color? color;

  @override
  _TableCustomState<T> createState() => _TableCustomState<T>();
}

class _TableCustomState<T> extends State<TableCustom<T>> {
  int pageSizeValue = PagingValues.getInstance().getPageSize();
  int pressedIndex = -10;
  @override
  void initState() {
      widget.actionButton?.removeWhere((element) => element.permissionGranted == false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // int serialNumber = widget.paginatePage != null ?(((widget.paginatePage!.currentPage - 1) * widget.paginatePage!.pageSize)): 0;
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
                if(widget.headTitles.serialNumberTitle != null) Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(widget.headTitles.serialNumberTitle!,overflow: TextOverflow.ellipsis,maxLines: 2,style: const TextStyle(fontWeight: FontWeight.w400),),
                ),
                ...List.generate(widget.headTitles.heardTileItems!.length, (x) =>   widget.headTitles.heardTileItems?[x].columnSize != null
                    ? Container(
                  width: widget.headTitles.heardTileItems?[x].columnSize,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment:  widget.headTitles.heardTileItems?[x].alignment != null ? widget.headTitles.heardTileItems![x].alignment: Alignment.centerLeft,
                  child: Text(widget.headTitles.heardTileItems![x].titleName!,overflow: TextOverflow.ellipsis,maxLines: 2,),
                )
                    : Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment:  widget.headTitles.heardTileItems?[x].alignment != null ? widget.headTitles.heardTileItems![x].alignment: Alignment.centerLeft,
                      child: Text(widget.headTitles.heardTileItems![x].titleName!,overflow: TextOverflow.ellipsis,maxLines: 2,),
                    )
                )
                ),
                if(widget.headTitles.actionTitle != null && widget.actionButton!.isNotEmpty ) Container(
                  width: 122,
                  alignment: Alignment.center,
                  child: Text(widget.headTitles.actionTitle!,overflow: TextOverflow.ellipsis,maxLines: 2,style: const TextStyle(fontWeight: FontWeight.w400),),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: ScrollController(),
            shrinkWrap: true,
              itemCount: widget.dataList.length,
              itemBuilder: (_, index) {
                return Card(
                  color: widget.color ?? Theme.of(context).primaryColor,
                  child: ListTile(
                    dense: true,

                    title: Row(
                      children: [
                            if(widget.headTitles.serialNumberTitle != null) SizedBox(
                          width: 50,
                          child: Text('${(index +1) + ((widget.paginatePage!.currentPage - 1) * widget.paginatePage!.pageSize)}',overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ),

                        ...List.generate( widget.headTitles.heardTileItems!.length, (i) =>  widget.headTitles.heardTileItems?[i].columnSize != null
                            ? Container(
                          width: widget.headTitles.heardTileItems?[i].columnSize,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment:  widget.headTitles.heardTileItems?[i].alignment != null ? widget.headTitles.heardTileItems![i].alignment: Alignment.centerLeft,
                          ///SUB-OBJECT CAN BE ADDED HERE
                          child: widget.headTitles.heardTileItems?[i].objectKeyField != null
                              ? Text(widget.dataList[index][widget.headTitles.heardTileItems?[i].titleKey] == null ? '---':widget.dataList[index][widget.headTitles.heardTileItems?[i].titleKey][widget.headTitles.heardTileItems?[i].objectKeyField].toString().replaceAll('_', ' ').replaceAll('null', '---'),overflow: TextOverflow.ellipsis,maxLines: 2,)
                              : Text(widget.dataList[index][widget.headTitles.heardTileItems?[i].titleKey].toString().replaceAll('_', ' ').replaceAll('null', '---'),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ): Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              alignment: widget.headTitles.heardTileItems?[i].alignment != null ? widget.headTitles.heardTileItems![i].alignment: Alignment.centerLeft,
                              child: widget.headTitles.heardTileItems?[i].objectKeyField != null
                                  ? Text(widget.dataList[index][widget.headTitles.heardTileItems?[i].titleKey] == null ? '---':widget.dataList[index][widget.headTitles.heardTileItems?[i].titleKey][widget.headTitles.heardTileItems?[i].objectKeyField].toString().replaceAll('_', ' ').replaceAll('null', '---'),overflow: TextOverflow.ellipsis,maxLines: 2,)
                                  : Text(widget.dataList[index][widget.headTitles.heardTileItems?[i].titleKey].toString().replaceAll('_', ' ').replaceAll('null', '---'),overflow: TextOverflow.ellipsis,maxLines: 2,),
                            )
                        )),
                        if(widget.headTitles.actionTitle!.isNotEmpty) SizedBox(
                          width: 122,
                          height:30,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if(widget.actionButton!.isNotEmpty) QudsPopupButton(
                                  tooltip: 'More',
                                  items: List.generate(widget.actionButton!.length, (pressIndex) => QudsPopupMenuItem(
                                      leading: Icon(widget.actionButton![pressIndex].icon),
                                      title: Text(widget.actionButton![pressIndex].name),
                                      onPressed: () {
                                        widget.actionButton![pressIndex].onPressed(widget.dataList[index]);
                                      })),
                                  // widthSize: 200,
                                  child: FloatingActionButton(
                                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                                    mini: true,
                                    elevation: 10,
                                    onPressed: null,
                                    child: Icon(Icons.more_vert_sharp, size: 15,color: Theme.of(context).cardColor,),
                                  ),
                                ),
                                if(widget.actionButton!.isNotEmpty) Container(width: 5,),
                                widget.deleteData == true
                                    ? widget.onDeleteLoader && pressedIndex == index
                                    ? const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.red,
                                ),
                                      ),
                                    ): FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.red,
                                  tooltip: 'Delete',
                                  child: const Icon(Icons.delete_outline,color: Colors.white,size: 17,),
                                  onPressed: (){
                                    deleteConfirm(index);
                                  },
                                ) : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),

        if(widget.paginatePage != null) Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Page Size'),
                        ),
                        Container(width: 10,),
                        DropdownButton(
                          isDense: true,
                          underline: Container(),
                          value: pageSizeValue,
                            items: const [
                              DropdownMenuItem(
                                value: 10,
                                  child: Text('10')),
                             DropdownMenuItem(
                                value: 20,
                                  child: Text('20')),
                               DropdownMenuItem(
                                value: 50,
                                  child: Text('50')),
                               DropdownMenuItem(
                                value: 100,
                                  child: Text('100')),
                            ],
                            onChanged: (value){
                            setState(() {
                              pageSizeValue = int.parse(value.toString());
                              widget.onPageSize(value);
                            });

                            }
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

  deleteConfirm(index){
    var size = MediaQuery.of(context).size;
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.height / 9,
                  width: size.height / 9,
                    child: SvgPicture.asset('assets/file.svg',package: 'shared_component',)),
                const Center(child: Text('Are you sure?')),
              ],
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: (){
                        pressedIndex = index;
                        widget.onDelete!(widget.dataList[index]['uid']);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                      ),
                      child: const Text('Delete',style: TextStyle(color: Colors.red),)),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          overlayColor:  MaterialStateProperty.all<Color>(Colors.transparent)
                      ),
                      child: const Text('Cancel')),
                ],
              )
            ],
          );
        }
    );
  }
}


///PAGINATE CLASS
class PaginatePage extends StatefulWidget {
  const PaginatePage({
    Key? key,
    this.currentPage = 0,
    this.totalPages = 0,
    this.pageSize = 0,
     this.onNavigateToPage,
    this.currentPageColors = Colors.teal,
    this.nextPage = 0}) : super(key: key);
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
        if(widget.currentPage > 2) FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 7,
            mini: true,
            child: Text((1).toString(),style: Theme.of(context).textTheme.caption,),
            onPressed: (){
             setState(() {
               widget.onNavigateToPage!(const PaginatePage(nextPage: 1,));
             });
            }),

        ///CONTINUES DOTS
        if(widget.currentPage > 2) SizedBox(
          width: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Container(
                  )),
              Text('.....',style: Theme.of(context).textTheme.bodyText2,)
            ],
          ),
        ),

        ///PREVIOUS PAGE
       if(widget.currentPage > 1) FloatingActionButton(
            backgroundColor: Colors.white,
          elevation: 7,
          mini: true,
            child: Text((widget.currentPage - 1).toString(),style: Theme.of(context).textTheme.caption),
            onPressed: (){
              widget.onNavigateToPage!(PaginatePage(nextPage: widget.currentPage - 1,));
            }),

        Container(width: 5,),
        ///CURRENT PAGE
        FloatingActionButton(
          backgroundColor: widget.currentPageColors,
            elevation: 7,
          mini: true,
            child: Text((widget.currentPage).toString(),style: TextStyle(fontSize: Theme.of(context).textTheme.caption!.fontSize,color: Theme.of(context).cardColor),),
            onPressed: (){}),

        Container(width: 5,),
        ///NEXT PAGE
       if(widget.totalPages > widget.currentPage) FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 7,
          mini: true,
            child: Text((widget.currentPage + 1).toString(),style: Theme.of(context).textTheme.caption,),
            onPressed: (){
              setState(() {
                widget.onNavigateToPage!(PaginatePage(nextPage: widget.currentPage + 1,));
              });
            }),

        ///CONTINUES DOTS
        if(widget.totalPages > (widget.currentPage + 1)) SizedBox(
          width: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Container(
                  )),
              Text('.....',style: Theme.of(context).textTheme.bodyText2,)
            ],
          ),
        ),

        ///TOTAL PAGES
        if(widget.totalPages > (widget.currentPage + 1)) FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 7,
            mini: true,
            child: Text((widget.totalPages).toString(),style: Theme.of(context).textTheme.caption,),
            onPressed: (){
              setState(() {
                widget.onNavigateToPage!(PaginatePage(nextPage: widget.totalPages,));
              });
            }),
      ],
    );
  }
}

class HeardTitle{
  final String? serialNumberTitle;
  final String? actionTitle;
  final List<HeardTitleItem>? heardTileItems;

  HeardTitle(
      {this.serialNumberTitle,
      this.actionTitle,
      this.heardTileItems});
}

class HeardTitleItem {
  final String? titleKey;
  final String? titleName;
  final String? objectKeyField;
  final double? columnSize;
  final Alignment? alignment;


  HeardTitleItem(

      {this.titleKey,
      this.titleName,
      this.objectKeyField,
      this.columnSize,
      this.alignment});
}

class ActionButtonItem<T>{
  final IconData icon;
  final String name;
  final Function(T) onPressed;
  final bool permissionGranted;
  final bool isDate;

  ActionButtonItem({this.isDate = false,this.permissionGranted = true, required this.icon, required this.name, required this.onPressed});
}

class PagingValues{

  static PagingValues? _instance;

  int? _pageSize;

  static PagingValues getInstance(){
    _instance ??= PagingValues();
    return _instance!;
  }

  clearInstance() {
    _instance = null;
  }

  int getPageSize() => _pageSize ?? 10;

  setPageSize(value) => _pageSize = value;
}

