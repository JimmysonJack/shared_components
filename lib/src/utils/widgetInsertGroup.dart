import 'package:flutter/material.dart';

class WidgetsGroup{
  final BuildContext context;
  List<Widget?> elementWidgets;
  List<int>? elementSizes;
  final String? header;

  WidgetsGroup({required this.context, required this.elementWidgets, this.elementSizes, this.header});

   Widget show(){
    var size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.only(top: (size.height /2) * 0.06,bottom: (size.height /2) * 0.05,right: (size.height /2) * 0.05,left: (size.height /2) * 0.05),
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: (size.height /2) * 0.03),
              child: Text(header ?? '',style: TextStyle(color: Theme.of(context).hintColor,fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),)),

          LayoutBuilder(
            builder:(context, buildSize) {
              return SizedBox(
                width: buildSize.maxWidth,
                child: Wrap(
                  // alignment: WrapAlignment.spaceBetween,
                  // spacing: 10,
                  runSpacing: 20,
                  children: List.generate(elementWidgets.length, (index) => elementSizes?.length == 1 && elementSizes?.elementAt(0) == 1 || elementSizes?.elementAt(index) == null ? elementWidgets.elementAt(index)! : Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: SizedBox(
                      width:(buildSize.maxWidth / (elementSizes?.elementAt(index) ?? 1)) - (elementSizes == null || elementSizes!.elementAt(index) == 1 ? 0 :  20),
                      child: elementWidgets[index],
                    ),
                  )),
                ),
              );
            },
          )

        ],
      ),
    );
  }

}