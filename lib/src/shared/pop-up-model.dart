// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../shared_component.dart';
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
      super.inputType,
      super.endpointName,
      super.refetchData,
      super.inputObjectFieldName,
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
      this.inputType,
      this.inputObjectFieldName,
      this.iconButton,
      this.refetchData = true,
      this.checkUnSavedData = true,
      this.modelWidth});
  final BuildContext buildContext;

  ///[modelWidth] is used to set a model width, maximum is 1.0
  final double? modelWidth;

  final bool refetchData;

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

  /// This will be used to provide fields that wil be returned
  final String? queryFields;

  ///This will return saved data and loading state
  final Function(Map<String, dynamic>?, bool)? responseResults;

  ///This is used to provide graphql endpoint name
  final String? endpointName;

  ///This will provide inputs tha endpoint needs
  final List<InputParameter>? inputs;

  /// If endpoint input field is an object, this will be used to give that field names
  final String? inputObjectFieldName;

  ///This provides inputs type
  final String? inputType;

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
        onConfirmBtnTap: () => Navigator.of(context).pop(true)));
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
                    // direction: Axis.vertical,
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
                                  console(!Field.use.updateState);
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
                            maxHeight:
                                (size.height * 0.89) - (size.height * 0.156),
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
                        Observer(builder: (context) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, right: 10, left: 10),
                              child: Field.use.button(
                                  // widthSize: WidthSize.col1,
                                  context: context,
                                  icon: iconButton,
                                  label: buttonLabel!,
                                  validate: true,
                                  onPressed: loading
                                      ? null
                                      : () {
                                          // print(FieldValues.getInstance().instanceValues);
                                          console(inputs);
                                          console(
                                              'input maker ${inputMaker()}');
                                          loading = true;
                                          if (onButtonPressed == null) {
                                            GraphQLService.mutate(
                                                context: context,
                                                refetchData: refetchData,
                                                response: (result, load) {
                                                  loading = load;
                                                  if (responseResults != null) {
                                                    responseResults!(
                                                        result, load);

                                                    if (result?['status']) {
                                                      Navigator.pop(context);
                                                    }
                                                  } else {
                                                    if (result?['status']) {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                },
                                                endPointName: endpointName!,
                                                queryFields: queryFields!,
                                                inputs: inputs ?? inputMaker());
                                          }
                                        }),
                            ),
                          );
                        })
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

  List<InputParameter> inputMaker() {
    console(FieldValues.getInstance().instanceValues);
    if (inputObjectFieldName != null) {
      return [
        InputParameter(
            inputType: inputType!,
            fieldName: inputObjectFieldName!,
            objectValues: FieldValues.getInstance()
                .instanceValues
                .map((e) => InputParameter(
                    inputType: e[e.keys.last],
                    fieldName: e.keys.first,
                    fieldValue: e.values.first is Map
                        ? e.values.first[e.values.first['inputValueField']]
                        : e.values.first))
                .toList())
      ];
    }
    return FieldValues.getInstance()
        .instanceValues
        .map((e) => InputParameter(
            inputType: e[e.keys.last],
            fieldName: e.keys.first,
            fieldValue: e.values.first))
        .toList();
  }
}

class PopDialog {
  static showWidget(
      {required String title,
      required BuildContext context,
      required Widget child,
      double? modelWidth}) async {
    showAnimatedDialog(
      context: context,
      axis: Axis.vertical,
      alignment: Alignment.center,
      curve: Curves.easeInOutQuart,
      barrierDismissible: false,
      animationType: DialogTransitionType.size,
      duration: const Duration(milliseconds: 800),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        var buildSize = MediaQuery.of(context).size.width;
        var size = MediaQuery.of(context).size;

        return Container(
          // color: Colors.cyanAccent,
          constraints: BoxConstraints(
              maxHeight: size.height * 0.95, minHeight: size.height * 0.0),
          child: Dialog(
            child: Container(
              color: Theme.of(context).cardColor,
              width: buildSize * (modelWidth ?? 0.5),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  ///Dialog [AppBar]
                  AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    title: Text(
                      title.toUpperCase(),
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(Icons.clear),
                          ),
                        ),
                      )
                    ],
                  ),
                  Flexible(fit: FlexFit.loose, child: child)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
