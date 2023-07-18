import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class DialogManager extends StatelessWidget {
  const DialogManager({Key? key, this.elementSizes, required this.elementWidgets, required this.dialogWidth, required this.title, required this.buttonName, this.icon, required this.onPressed, this.formValidator}) : super(key: key);
  final List<int>? elementSizes;
  final List<Widget> elementWidgets;
  final int dialogWidth;
  final String title;
  final String buttonName;
  final Icon? icon;
  final dynamic formValidator;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    int? elSize = elementSizes?.where((element) => element > 1).toList().length ?? 0;

    if(elementSizes != null && elementSizes!.length > 1){
      elSize = (elementSizes!.length - elSize) + (elSize / 2).round();
    }
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4))
        ),
        automaticallyImplyLeading: formValidator.hasErrors ? false : false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(title.toUpperCase(),style: Theme.of(context).textTheme.labelLarge,),
        actions:  [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Tooltip(
              message: 'Close',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                child: Icon(CupertinoIcons.clear,color:Theme.of(context).cardColor),
                onTap: (){
                  Modular.to.pop();
                },
              ),
            ),
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            child: LayoutBuilder(
              builder:(context, buildSize) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: buildSize.maxWidth,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 20,
                      children: List.generate(elementWidgets.length, (index) => SizedBox(
                        width:elementSizes?.length == 1
                            ? (buildSize.maxWidth / elementSizes![0]) - 20
                            : (buildSize.maxWidth / (elementSizes?[index] ?? 1)) - (elementSizes == null ? 0 : 20),
                        child: elementWidgets[index],
                      )),
                    ),
                  ),
                );
              },
            ),
          );
        }
      ),
    );

  }
}

