

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ui/google_ui.dart';
import 'package:shared_component/shared_component.dart';

import 'dialogManager.dart';
// import 'package:xagent/app/shared/dialog/dialogManager.dart';

class DialogService {
  final BuildContext context;
  final List<int>? elementSizes;
  final List<Widget> elementWidgets;
  final int dialogWidth;
  final String title;
  final String? buttonName;
  final Icon? icon;
  final Function()? onPressed;
  final bool min;
  final dynamic loader;
  final  dynamic formValidator;

  DialogService(
      {this.buttonName,
        this.icon,
        this.loader = false,
        this.formValidator,
        this.min = false,
        this.onPressed,
        required this.title,
        required this.context,
        this.elementSizes,
        required this.elementWidgets,
        required this.dialogWidth});

  show(){
    // FToast().init(context);
    var size = MediaQuery.of(context).size;
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (context,animOne, animTwo){
          return Observer(
            builder:(_) => Dialog(
              child: SizedBox(
                width: size.width / dialogWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(loader.loading)  IndicateProgress.linear(),
                    formValidator.hasErrors ? const SizedBox() : const SizedBox(),
                    if(min) AppBar(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4))
                      ),
                      automaticallyImplyLeading: formValidator.hasErrors ? false : false,
                      backgroundColor: Theme.of(context).primaryColor,
                      title: Text(title.toUpperCase(),style: Theme.of(context).textTheme.button,),
                      actions:  [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Tooltip(
                            message: 'Close',
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              child: Icon(CupertinoIcons.clear,color: Theme.of(context).secondaryHeaderColor,),
                              onTap: (){
                                Modular.to.pop();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    if(!min) Expanded(
                      flex: min ? 0 : 1,
                      child: DialogManager(
                        title: title,
                        formValidator: formValidator,
                        onPressed: onPressed ?? (){},
                        buttonName: buttonName ?? '',
                        dialogWidth: dialogWidth,
                        elementWidgets: elementWidgets,
                        elementSizes: elementSizes,
                        icon: icon,
                      ),
                    ),
                    if(min) LayoutBuilder(
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
                    if(buttonName != null)LayoutBuilder(
                      builder: (context,buildSize) => Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: buildSize.maxWidth / 4,
                            child:  GElevatedButton(
                                buttonName!,
                                onPressed:!formValidator.hasErrors ? !loader.loading ? (){
                                  onPressed!();

                                } : null : null,
                                icon: icon
                            ),
                          ),
                        ),
                      ),
                    ),
                    // TextField(
                    //   onChanged: (value) => store.validatingInputs([]),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
  }


}