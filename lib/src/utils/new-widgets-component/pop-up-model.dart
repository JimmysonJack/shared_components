import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_component/src/utils/new-widgets-component/graphql_service.dart';
import 'package:shared_component/src/utils/new-widgets-component/notification_service.dart';
import 'package:shared_component/src/utils/new-widgets-component/settings_service.dart';

import '../../../shared_component.dart' hide Store;
part 'pop-up-model.g.dart';

class PopupModel extends _PopupModelBase with _$PopupModel {
  PopupModel(
      {required super.buildContext,
      required super.formGroup,
      super.title,
      super.modelWidth,
      super.buttonLabel,
      super.iconButton,
      super.checkUnSavedData,
      super.inputs,
      super.responseResults,
      super.queryFields,
      super.endpointName,
      super.onButtonPressed});

}

abstract class _PopupModelBase with Store {

  _PopupModelBase(
      {required this.buildContext,
      this.title = 'dialog Service',
      required this.formGroup,
        this.queryFields,
        this.responseResults,
        this.endpointName,
        this.inputs,
        this.buttonLabel,
      this.onButtonPressed,
      this.iconButton,
      this.checkUnSavedData = false,
      this.modelWidth});
  final BuildContext buildContext;

  ///[modelWidth] is used to set a model width, maximum is 1.0
  final double? modelWidth;

  ///[title] is for providing your dialog model with name
  final String title;

  ///[children] this is a list of widgets that will be displayed
  final FormGroup formGroup;

  ///[buttonLabel] this is for button name
  final String? buttonLabel;

  ///[onButtonPressed] is for action when button is pressed
  final Function()? onButtonPressed;

  ///[iconButton] this will display an icon to a button
  final IconData? iconButton;

  ///[checkUnSavedData] this will be used to check if data that entered is saved or not
  final bool checkUnSavedData;

  final String? queryFields;

  final Function(Map<String,dynamic>?,bool)? responseResults;

  final String? endpointName;

  final List<InputParameter>? inputs;

  @observable
  double buildSize = 0;

  @observable
  bool loading = false;

  @observable
  bool _errors = true;

  @computed
  bool get hasErrors => _errors;

  Future<bool> _onWillPop(context) async {
    return (await NotificationService.confirmInfo(
        context: context,
      title: 'Closing Dialog?',
      content: 'Changes you made may not be saved',
      cancelBtnText: 'No',
      confirmBtnText: 'Yes',
      showCancelBtn: true,
      onCancelBtnTap: () => Navigator.of(context).pop(false),
      onConfirmBtnTap: () => Navigator.of(context).pop(true)

    ));
  }

  show() async {
    hasError.addListener(() {
      _errors = hasError.value;
    });
    FieldValues.clearInstance();

    showAnimatedDialog(
      context: buildContext,
      axis: Axis.vertical,
      alignment: Alignment.center,
      curve: Curves.easeInOutQuart,
      barrierDismissible: false,
      animationType: DialogTransitionType.size,
      duration: const Duration(milliseconds: 800),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        buildSize = MediaQuery.of(context).size.width;
        var size = MediaQuery.of(context).size;
        return WillPopScope(
          onWillPop: () async => false,
          child: Observer(builder: (context) {
            return Container(
              // color: Colors.cyanAccent,
              constraints: BoxConstraints(
                  maxHeight: size.height * 0.95, minHeight: size.height * 0.0),
              child: Dialog(
                child: Container(
                  color: Theme.of(context).cardColor,
                  width: buildSize * (modelWidth ?? 0.5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///Dialog [AppBar]
                      AppBar(
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        title: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontSize),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () async {
                                if (checkUnSavedData) {
                                  if (!Field.use.updateState) {
                                    if (await _onWillPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(Icons.clear),
                              ),
                            ),
                          )
                        ],
                      ),
                      if (loading) IndicateProgress.linear(),
                     Container(
                       padding: const EdgeInsets.all(10.0),
                       constraints: BoxConstraints(
                           maxHeight: (size.height * 0.89) -
                               (size.height * 0.156),
                           minHeight: size.height * 0.0),
                       child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return formGroup;
                            },
                          ),
                     ),
                      ///Submit button
                      if (buttonLabel != null)
                        Observer(
                          builder: (context) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10.0, right: 10),
                                child: Field.use.button(
                                    context: context,
                                    icon: iconButton,
                                    label: buttonLabel!,
                                    validate: true,
                                    onPressed: loading ? null : () {
                                      // print(FieldValues.getInstance().instanceValues);
                                      loading = true;
                                      if(onButtonPressed == null){
                                        GraphQLService.mutate(
                                          context: context,
                                            response: (responseResult, load){
                                              loading = load;
                                              if(responseResults != null) responseResults!(responseResult,load);
                                            },
                                            endPointName: endpointName!,
                                            queryFields: queryFields!,
                                            inputs: inputs ?? FieldValues.getInstance().instanceValues.map((e) => InputParameter(fieldName: e.keys.first, fieldValue: e.values.first)).toList());
                                      }

                                    }),
                              ),
                            );
                          }
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
