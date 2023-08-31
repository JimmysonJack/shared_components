// ignore_for_file: constant_identifier_names, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import '../../shared_component.dart' hide FilePicker;

part 'text-inputs.g.dart';

ValueNotifier valueNotifier = ValueNotifier('');

class TextInput extends _TextInputBase with _$TextInput {
  TextInput(
      {super.updateFields,
      required super.fieldController,
      required super.fieldValuesController});
}

abstract class _TextInputBase with Store {
  _TextInputBase(
      {this.updateFields,
      required this.fieldController,
      required this.fieldValuesController});
  final FieldController? fieldController;
  final FieldValuesController fieldValuesController;

  static const _locale = 'sw_TZ';
  static const _customKey = CustomDisplayKey();

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  // List<Map<String, dynamic>> _values = [];

  @observable
  List<Map<String, dynamic>>? updateFields;

  List<Map<String, dynamic>> uniqueListData = [];

  Set<dynamic> uniqueKeys = {};

  @action
  setUpdateFields(List<Map<String, dynamic>>? value) {
    var list = updateFields;
    list = value;
    updateFields = list;
  }

  @observable
  List<Map<String, dynamic>> items = [];
  // @observable
  // dynamic initialValue;
  @observable
  bool _showPassword = false;

  @observable
  bool updateState = false;

  @observable
  bool _checkBoxState = false;

  @action
  setCheckBoxState(bool? value) => _checkBoxState = !_checkBoxState;

  @observable
  bool _switchState = false;

  final Map<String, bool> _validationMap = {};
  // List<Map<String, dynamic>> _validationList = [];

  @observable
  bool hasErrors = false;

  String? selectedKey;

  @action
  setSwitchState(bool? value) => _switchState = !_switchState;

  Widget input(
      {required BuildContext context,
      required String label,
      WidthSize? widthSize,
      required String key,
      bool isPassword = false,
      bool isTextArea = false,
      int maxLines = 1,
      bool fixed = false,
      int minLines = 1,
      String? inputType = 'String',
      bool readOnly = false,
      bool enabled = true,
      bool? validate = false,
      bool show = false,
      FieldInputType? fieldInputType}) {
    // checkForUpdate(key, label, fieldInputType, validate, null);

    return LayoutBuilder(builder: (context, x) {
      return SizedBox(
        width: sizeSet(widthSize, context, fixed: fixed),
        child: TextFormField(
          inputFormatters: inputFormatter(fieldInputType),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {},
          onChanged: (value) {
            if (fieldInputType == FieldInputType.Currency) {
              validateErrors(key, label, fieldInputType, validate, value);

              _onUpdate(key, value.replaceAll(",", ""), inputType);
            } else {
              validateErrors(key, label, fieldInputType, validate, value);

              _onUpdate(key, value, inputType);
            }
          },
          validator: (value) {
            return generalValidator(value, label, fieldInputType, validate);
          },
          obscureText: _showPassword,
          maxLines: isTextArea
              ? maxLines == 1
                  ? maxLines = 5
                  : maxLines
              : maxLines,
          minLines: isTextArea
              ? minLines == 1
                  ? 1
                  : minLines > maxLines
                      ? maxLines
                      : minLines
              : minLines > maxLines
                  ? maxLines
                  : minLines,
          readOnly: readOnly,
          enabled: enabled,
          initialValue: onInitialValue(updateFields, key, fieldInputType,
              validate ?? false, label, inputType!),
          autovalidateMode: onInitialValue(updateFields, key, fieldInputType,
                      validate ?? false, label, inputType) ==
                  null
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.always,
          // contextMenuBuilder: (context,editableState){
          //   return editableState.widget.
          // },
          decoration: InputDecoration(
            border: isTextArea
                ? OutlineInputBorder(borderRadius: BorderRadius.circular(0))
                : null,
            suffixIcon: isPassword
                ? InkWell(
                    onTap: () {
                      show = !show;
                      _showPassword = show;
                    },
                    child: Icon(!_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )
                : null,
            prefixText: fieldInputType == FieldInputType.Currency
                ? "$_currency "
                : null,
            labelText: label,
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),
      );
    });
  }

  Widget select(
      {required BuildContext context,
      required String label,
      WidthSize? widthSize,
      required String key,
      bool readOnly = false,
      bool? validate = false,
      List<Map<String, dynamic>>? items,
      bool isPageable = false,
      String Function(Map<String, dynamic>)? inFieldString,
      Function(bool isOpenned)? onOverlay,
      CustomDisplayKey customDisplayKey = _customKey,
      String? queryFields,
      String? endPointName,
      String? inputType = 'String',
      bool fixed = false,
      bool? isMap = false,
      List<OtherParameters>? otherParameters,
      FieldInputType? fieldInputType}) {
    // checkForUpdate(key, label, fieldInputType, validate, updateFields ?? []);

    final size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, x) {
      return SizedBox(
        width: sizeSet(widthSize, context, fixed: fixed),
        child: DropdownSearch<Map<String, dynamic>>(
            isPageable: isPageable,
            enabled: !readOnly,
            clearButtonProps: const ClearButtonProps(
              icon: Icon(Icons.close),
              isVisible: true,
              tooltip: 'Clear Field',
            ),
            autoValidateMode: onInitialValue(updateFields, key, fieldInputType,
                        validate ?? false, label, inputType!) ==
                    null
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.always,
            validator: (value) {
              return generalValidator(
                  value?[customDisplayKey.titleDisplayLabelKey],
                  label,
                  fieldInputType,
                  validate);
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                textAlignVertical: TextAlignVertical.center,
                baseStyle: const TextStyle(fontSize: 16),
                dropdownSearchDecoration: InputDecoration(
                    enabled: !readOnly,
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: null,
                    labelText: label,
                    // labelStyle: const TextStyle(locale: Locale('sw')),
                    isDense: false)),
            compareFn: (selected, item) {
              return SettingsService.use.areEqual(selected, item);
            },
            popupProps: PopupProps.menu(
                fit: FlexFit.loose,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    autofocus: true,
                    decoration: InputDecoration(
                        hintMaxLines: 1,
                        isDense: true,
                        labelText: 'Search',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Theme.of(context).dividerColor)),
                onDismissed: () {
                  if (onOverlay != null) {
                    onOverlay(false);
                  }
                },
                containerBuilder: (cxt, widget) {
                  if (onOverlay != null) {
                    onOverlay(true);
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: size.height * 0.35,
                          minHeight: size.height * 0.0,
                        ),
                        child: widget,
                      ),
                      // const Center(
                      //   child: Padding(
                      //     padding: EdgeInsets.all(8.0),
                      //     child: Text('Loading More...'),
                      //   ),
                      // )
                    ],
                  );
                },
                isFilterOnline: endPointName?.isNotEmpty ?? false,
                searchDelay: Duration.zero,
                showSelectedItems: true,
                loadingBuilder: (cxt, value) {
                  return IndicateProgress.circular();
                },
                itemBuilder: (cxt, Map<String, dynamic> value, isSelected) {
                  return ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: Theme.of(cxt).secondaryHeaderColor,
                    title: Text(value[customDisplayKey.titleDisplayLabelKey]),
                    subtitle: customDisplayKey.subtitleDisplayLabelKey == null
                        ? null
                        : Text(
                            value[customDisplayKey.subtitleDisplayLabelKey] ??
                                ''),
                  );
                },
                scrollbarProps: ScrollbarProps(
                    interactive: true,
                    notificationPredicate: (notification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {}

                      return true;
                    }),
                menuProps: const MenuProps(
                  animationDuration: Duration(milliseconds: 0),
                ),
                listViewProps: const ListViewProps(
                  // controller: scrollController,
                  shrinkWrap: true,
                )),
            asyncItems: (String filter, nextPage) async {
              if (isPageable) {
                final results = await GraphQLService.queryPageable(
                    context: context,
                    endPointName: endPointName ?? '',
                    parameters: otherParameters,
                    pageableParams: PageableParams(
                      searchKey: filter,
                      size: 20,
                      page: nextPage ?? 0,
                    ),
                    responseFields: queryFields ?? '');
                return results
                    .where((element) =>
                        element[customDisplayKey.titleDisplayLabelKey]
                            .toString()
                            .toLowerCase()
                            .contains(filter.toLowerCase()))
                    .toList();
              } else {
                if (endPointName != null) {
                  final results = await GraphQLService.query(
                      context: context,
                      endPointName: endPointName,
                      parameters: otherParameters,
                      responseFields: queryFields ?? '');

                  var mapResults =
                      List<Map<String, dynamic>>.from(results.data);
                  return mapResults
                      .where((element) =>
                          element[customDisplayKey.titleDisplayLabelKey]
                              .toString()
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                      .toList();
                } else {
                  return [];
                }
              }
            },
            items: items ?? [],
            itemAsString: inFieldString ??
                (value) => "${value[customDisplayKey.titleDisplayLabelKey]}",
            selectedItem: onInitialValue(updateFields, key, fieldInputType,
                validate ?? false, label, inputType),
            onChanged: (data) {
              if (isMap == false) {
                data?['inputValueField'] = customDisplayKey.inputValueField;
              }
              validateErrors(key, label, fieldInputType, validate,
                  data?[customDisplayKey.titleDisplayLabelKey]);
              _onUpdate(key, data, inputType);
            }),
      );
    });
  }

  Widget multiSelect(
      {required BuildContext context,
      required String label,
      WidthSize? widthSize,
      required String key,
      bool readOnly = false,
      bool? validate = false,
      List<Map<String, dynamic>>? items,
      bool isPageable = false,
      String Function(Map<String, dynamic>)? inFieldString,
      CustomDisplayKey customDisplayKey = _customKey,
      String? queryFields,
      String? endPointName,
      String? inputType = 'String',
      bool fixed = false,
      List<OtherParameters>? otherParameters,
      FieldInputType? fieldInputType}) {
    // checkForUpdate(key, label, fieldInputType, validate, updateFields ?? []);

    final size = MediaQuery.of(context).size;
    return LayoutBuilder(
        // name: 'MultSelect',
        builder: (context, x) {
      return SizedBox(
        width: sizeSet(widthSize, context, fixed: fixed),
        child: DropdownSearch<Map<String, dynamic>>.multiSelection(
            isPageable: isPageable,
            enabled: !readOnly,
            clearButtonProps: const ClearButtonProps(
              icon: Icon(Icons.close),
              isVisible: true,
              tooltip: 'Clear Field',
            ),
            autoValidateMode: onInitialValue(updateFields, key, fieldInputType,
                        validate ?? false, label, inputType!) ==
                    null
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.always,
            validator: (value) {
              return generalValidator(value, label, fieldInputType, validate);
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                textAlignVertical: TextAlignVertical.center,
                baseStyle: const TextStyle(fontSize: 16),
                dropdownSearchDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 21.5, horizontal: 10),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: null,
                    labelText: label,
                    // labelStyle: const TextStyle(locale: Locale('sw')),
                    isDense: false)),
            compareFn: (selected, item) {
              return SettingsService.use.areEqual(selected, item);
            },
            popupProps: PopupPropsMultiSelection.menu(
                fit: FlexFit.loose,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    autofocus: true,
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Search',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Theme.of(context).dividerColor)),
                containerBuilder: (cxt, widget) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: size.height * 0.35,
                          minHeight: size.height * 0.0,
                        ),
                        child: widget,
                      ),
                      // const Center(
                      //   child: Padding(
                      //     padding: EdgeInsets.all(8.0),
                      //     child: Text('Loading More...'),
                      //   ),
                      // )
                    ],
                  );
                },
                isFilterOnline: endPointName?.isNotEmpty ?? false,
                searchDelay: Duration.zero,
                showSelectedItems: true,
                loadingBuilder: (cxt, value) {
                  return IndicateProgress.circular();
                },
                itemBuilder: (cxt, Map<String, dynamic> value, isSelected) {
                  return ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: Theme.of(cxt).secondaryHeaderColor,
                    title: Text(value[customDisplayKey.titleDisplayLabelKey]),
                    subtitle: customDisplayKey.subtitleDisplayLabelKey == null
                        ? null
                        : Text(
                            value[customDisplayKey.subtitleDisplayLabelKey] ??
                                ''),
                  );
                },
                scrollbarProps: ScrollbarProps(
                    interactive: true,
                    notificationPredicate: (notification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {}
                      //TODO Implement

                      return true;
                    }),
                menuProps: const MenuProps(
                  animationDuration: Duration(milliseconds: 0),
                ),
                listViewProps: const ListViewProps(
                  shrinkWrap: true,
                )),
            asyncItems: (String filter, nextPage) async {
              if (isPageable) {
                final results = await GraphQLService.queryPageable(
                    context: context,
                    endPointName: endPointName ?? '',
                    parameters: otherParameters,
                    pageableParams: PageableParams(
                      searchKey: filter,
                      size: 20,
                      page: nextPage ?? 0,
                    ),
                    responseFields: queryFields ?? '');
                return results
                    .where((element) =>
                        element[customDisplayKey.titleDisplayLabelKey]
                            .toString()
                            .toLowerCase()
                            .contains(filter.toLowerCase()))
                    .toList();
              } else {
                if (endPointName != null) {
                  final results = await GraphQLService.query(
                      context: context,
                      endPointName: endPointName,
                      parameters: otherParameters,
                      responseFields: queryFields ?? '');
                  var mapResults =
                      List<Map<String, dynamic>>.from(results.data);
                  return mapResults
                      .where((element) =>
                          element[customDisplayKey.titleDisplayLabelKey]
                              .toString()
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                      .toList();
                } else {
                  return [];
                }
              }
            },
            items: items ?? [],
            itemAsString: inFieldString ??
                (value) => "${value[customDisplayKey.titleDisplayLabelKey]}",
            selectedItems: onInitialValue(updateFields, key, fieldInputType,
                validate ?? false, label, inputType),
            onChanged: (data) {
              validateErrors(key, label, fieldInputType, validate, data);
              data.map((e) =>
                  {...e, 'inputValueField': customDisplayKey.inputValueField});
              _onUpdate(key, data, inputType);
            }),
      );
    });
  }

  Widget date({
    required BuildContext context,
    bool disableFuture = false,
    bool disablePast = false,
    bool flowTop = false,
    bool disable = false,
    bool isDateRange = false,
    bool validate = false,
    String? inputType = 'String',
    bool fixed = false,
    WidthSize? widthSize,
    Function(dynamic)? onSelectedDate,
    Function(bool isOpenned)? onOverlay,
    required String label,
    required String key,
  }) {
    // checkForUpdate(key, label, null, validate, updateFields ?? []);

    return LayoutBuilder(builder: (context, x) {
      return SizedBox(
        width: sizeSet(widthSize, context, fixed: fixed),
        child: CustomDate(
          onOverlay: (isOpenned) {
            if (onOverlay != null) {
              onOverlay(isOpenned);
            }
          },
          onSelected: (value) {
            validateErrors(key, label, null, validate, value);
            _onUpdate(key, value.toString(), inputType);
            // onSelectedDate!(FieldValues.getInstance().instanceValues);
          },
          validator: (value) {
            return generalValidator(
                value, label, FieldInputType.Other, validate);
          },
          textTypeInput: TextInputType.datetime,
          disableFuture: disableFuture,
          disablePast: disablePast,
          filled: true,
          flowTop: flowTop,
          enabled: !disable,
          labelText: label,
          isDateRange: isDateRange,
          readyOnly: true,
          showDateIcon: true,
          initialValue: onInitialValue(
              updateFields, key, null, validate, label, inputType!),
        ),
      );
    });
  }

  Widget attachment(
      {required String label,
      WidthSize? widthSize,
      required FieldInputType fieldInputType,
      FileType? fileType,
      bool? validate,
      String? inputType = 'String',
      required String key,
      required String fileNameKey,
      bool fixed = false,
      required BuildContext context}) {
    // checkForUpdate(key, label, fieldInputType, validate, updateFields ?? []);

    TextEditingController controller = TextEditingController();
    return LayoutBuilder(builder: (context, x) {
      return SizedBox(
        width: sizeSet(widthSize, context, fixed: fixed),
        child: TextFormField(
          initialValue: onInitialValue(updateFields, key, fieldInputType,
              validate ?? false, label, inputType!),
          onTap: () async {
            // FilePickerCross resultx = await FilePickerCross.importFromStorage(
            //   type: fileType ?? FileTypeCross.any,
            // );
            FilePickerResult? result = await FilePicker.platform
                .pickFiles(type: fileType ?? FileType.any);
            if (result != null) {
              PlatformFile fileData = result.files.first;
              controller.text = fileData.name;
              validateErrors(
                  key, label, fieldInputType, validate, fileData.name);

              _onUpdate(key, base64.encode(fileData.bytes!), inputType);
              _onUpdate(fileNameKey, fileData.name, inputType);
            }
          },
          readOnly: true,
          controller: controller,
          onChanged: (value) {},
          validator: (value) {
            return generalValidator(value, label, fieldInputType, validate);
          },
          decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              suffixIcon: const Icon(Icons.attach_file),
              prefixText: 'File Name: '),
        ),
      );
    });
  }

  Widget checkBox({
    required BuildContext context,
    WidthSize? widthSize,
    Function(bool?)? onChanged,
    bool fixed = false,
    bool currentValue = false,
    String? inputType = 'Boolean',
    String? label,
    MainAxisAlignment? align,
    required String key,
  }) {
    return Observer(builder: (context) {
      if (updateFields == null ||
          updateFields!.where((element) => element.containsKey(key)).isEmpty) {
        if (fieldValuesController.instanceValues
                .where((element) => element.containsKey(key))
                .isEmpty ||
            fieldValuesController.instanceValues
                    .where((element) => element.containsKey(key))
                    .first
                    .values
                    .first !=
                currentValue) {
          onInitialValue([
            {key: currentValue}
          ], key, null, false, 'Checkbox', inputType!);
        }
      } else {
        _checkBoxState = onInitialValue(
                updateFields, key, null, false, 'Checkbox', inputType!) ??
            false;
      }

      ///Helping to rebuild when a value changes
      _checkBoxState;

      return SizedBox(
        width: widthSize != null
            ? sizeSet(widthSize, context, fixed: fixed)
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: SettingsService.use.isEmptyOrNull(align)
              ? MainAxisAlignment.start
              : align!,
          children: [
            Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                value: fieldValuesController.instanceValues
                    .where((element) => element.keys.first == key)
                    .first
                    .values
                    .first,
                onChanged: (value) {
                  setCheckBoxState(value);
                  _onUpdate(key, value, inputType);

                  if (onChanged != null) onChanged(value);
                }),
            Text(
              label ?? '',
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      );
    });
  }

  Widget toggle({
    required BuildContext context,
    WidthSize? widthSize,
    String? inputType = 'Boolean',
    bool fixed = false,
    bool currentValue = false,
    Function(bool?)? onChanged,
    Alignment? align,
    required String key,
  }) {
    // checkForUpdate(key, null, null, false, updateFields ?? []);

    if (updateFields == null ||
        updateFields!.where((element) => element.containsKey(key)).isEmpty) {
      if (fieldValuesController.instanceValues
              .where((element) => element.containsKey(key))
              .isEmpty ||
          fieldValuesController.instanceValues
                  .where((element) => element.containsKey(key))
                  .first
                  .values
                  .first !=
              currentValue) {
        onInitialValue([
          {key: currentValue}
        ], key, null, false, 'Checkbox', inputType!);
      }
    } else {
      _switchState = onInitialValue(
              updateFields, key, null, false, 'Checkbox', inputType!) ??
          false;
    }

    return Observer(builder: (context) {
      ///Helps to rebuild a state
      _switchState;
      return Container(
        alignment: SettingsService.use.isEmptyOrNull(align)
            ? Alignment.centerLeft
            : align!,
        width: widthSize != null
            ? sizeSet(widthSize, context, fixed: fixed)
            : null,
        child: Switch(
            value: fieldValuesController.instanceValues
                .where((element) => element.keys.first == key)
                .first
                .values
                .first,
            onChanged: (value) {
              setSwitchState(value);
              _onUpdate(key, value, inputType);
              if (onChanged != null) onChanged(value);
            }),
      );
    });
  }

  Widget button(
      {required BuildContext context,
      WidthSize? widthSize,
      required String label,
      required Function()? onPressed,
      bool fixed = false,
      bool validate = true,
      Color? backgroundColor,
      IconData? icon}) {
    if (icon == null) {
      return Observer(
          // warnWhenNoObservables: false,
          builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: widthSize != null
                ? sizeSet(widthSize, context, fixed: fixed)
                : null,
          ),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5);
                    } else if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).disabledColor;
                    }
                    return backgroundColor ??
                        Theme.of(context)
                            .primaryColor; // Use the component's default.
                  },
                ),
              ),
              onPressed: validate
                  ? updateState &&
                          !SettingsService.use.isEmptyOrNull(updateFields)
                      ? null
                      : hasErrors
                          ? null
                          : onPressed
                  : onPressed,
              child: Text(label)),
        );
      });
    }
    return Observer(
        warnWhenNoObservables: false,
        builder: (context) {
          return SizedBox(
            width: widthSize != null
                ? sizeSet(widthSize, context, fixed: fixed)
                : null,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5);
                    } else if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).disabledColor;
                    }
                    return backgroundColor ??
                        Theme.of(context)
                            .primaryColor; // Use the component's default.
                  },
                ),
              ),
              onPressed: validate
                  ? updateState &&
                          SettingsService.use.isEmptyOrNull(updateFields)
                      ? null
                      : hasErrors
                          ? null
                          : onPressed
                  : onPressed,
              label: Text(label),
              icon: Icon(icon),
            ),
          );
        });
  }

  _onUpdate(String key, dynamic value, String? inputType) async {
    ///this is used for singleton
    final instanceValues = fieldValuesController.instanceValues;

    /// this is used for single instance only
    final fieldInstanceValues = fieldController?.instanceValues;
    updateFieldValue(key, value, inputType, instanceValues, true);
    updateFieldValue(key, value, inputType, fieldInstanceValues!, false);
  }

  updateFieldValue(String key, dynamic value, String? inputType,
      List<Map<String, dynamic>> dataList, bool useFieldValue) {
    final instanceMap = {for (var map in dataList) map.keys.first: map};
    String foundKey = instanceMap.containsKey(key) ? key : 'noKey';
    late int valueIndex;
    if ('noKey' == foundKey) {
      Map<String, dynamic> json = {key: value, 'inputType': inputType};
      useFieldValue
          ? fieldValuesController.addValue(json)
          : fieldController!.addValue(json);
    } else {
      valueIndex =
          dataList.indexWhere((rawValue) => rawValue.keys.first == foundKey);
      useFieldValue
          ? fieldValuesController.updateValue(value, foundKey, valueIndex)
          : fieldController!.updateValue(value, foundKey, valueIndex);
    }
    if (!useFieldValue) {
      fieldController!.hasErrors = hasErrors;
      fieldController!.updateField(fieldController!.instanceValues);
    } else {
      notifierValue.value = value;
    }
  }

  double sizeSet(WidthSize? widthSize, BuildContext context,
      {bool fixed = false}) {
    final screenSize = MediaQuery.of(context).size;
    double minusValue = 20;
    if (screenSize.width <= 1045 && !fixed) {
      return screenSize.width;
    }
    switch (widthSize) {
      case null:
        return (screenSize.width * 0.5) - minusValue;
      case WidthSize.col12:
        return screenSize.width;
      case WidthSize.col10:
        return (screenSize.width * (10 / 12)) - minusValue;
      case WidthSize.col8:
        return (screenSize.width * (8 / 12)) - minusValue;
      case WidthSize.col6:
        return (screenSize.width * (6 / 12)) - minusValue;
      case WidthSize.col4:
        return (screenSize.width * (4 / 12)) - minusValue;
      case WidthSize.col2:
        return (screenSize.width * (2 / 12)) - minusValue;
      case WidthSize.col11:
        return (screenSize.width * (11 / 12)) - minusValue;
      case WidthSize.col9:
        return (screenSize.width * (9 / 12)) - minusValue;
      case WidthSize.col7:
        return (screenSize.width * (7 / 12)) - minusValue;
      case WidthSize.col5:
        return (screenSize.width * (5 / 12)) - minusValue;
      case WidthSize.col3:
        return (screenSize.width * (3 / 12)) - minusValue;
      case WidthSize.col1:
        return (screenSize.width * (1 / 12)) - minusValue;
    }
  }

  checkForUpdate(key, validateName, fieldInputType, validate, dynamic value) {
    validateErrors(key, validateName, fieldInputType, validate, value);
  }

  List<TextInputFormatter> inputFormatter(FieldInputType? fieldInputType) {
    List<TextInputFormatter> list = [];
    if (fieldInputType == FieldInputType.UpperCase) {
      list.add(UpperCaseTextFormatter());
    }
    if (fieldInputType == FieldInputType.DigitOnly) {
      list.add(FilteringTextInputFormatter.digitsOnly);
    }
    if (fieldInputType == FieldInputType.MobileNumber) {
      list.addAll([
        FilteringTextInputFormatter.digitsOnly,
        // PhoneNumberTextInputFormatter()
        LengthLimitingTextInputFormatter(10)
      ]);
    }
    if (fieldInputType == FieldInputType.Currency) {
      list.addAll([CurrencyTextInputFormatter(symbol: '', decimalDigits: 0)]);
    }
    if (fieldInputType == FieldInputType.ServiceNumber) {
      list.add(UpperCaseTextFormatter());
    }
    return list;
  }

  onInitialValue(
      List<Map<String, dynamic>>? dataList,
      String key,
      FieldInputType? fieldInputType,
      bool validate,
      String validationName,
      String inputType) {
    ///setting [dataList] to null becouse it might throw a Bad state error when [dataList] is empty
    dataList = SettingsService.use.isEmptyOrNull(dataList) ? null : dataList;
    Map<String, dynamic>? dataMap;

    // Create a Set to store the keys of unique items
    if (dataList != null) {
      for (var data in dataList) {
        if (uniqueKeys.contains(data)) {
          // If the key is already in the uniqueKeys Set, skip to the next data item.
          continue;
        }

        if (data.keys.first == key || data.keys.first == 'uid') {
          data.addAll({'inputType': inputType});
          uniqueListData.add(data);
          uniqueKeys.add(data); // Add the key to the Set to mark it as unique.
        }
      }
    }
    // console(dataList);
    fieldValuesController.setValue(uniqueListData);
    dataMap = uniqueListData.firstWhere((data) => data.keys.first == key,
        orElse: () => <String, dynamic>{});

    checkForUpdate(key, validationName, fieldInputType, validate,
        dataMap.isEmpty ? null : dataMap.values.first);
    return dataMap.isEmpty ? null : dataMap.values.first;
  }

  // assignInitialValue(key,validateName,fieldInputType,validate) async {
  //   if (updateFields != null) {
  //     for (var element in updateFields!) {
  //       if (element.containsKey(key)) {
  //         initialValue = element[key];
  //         validateErrors(key, validateName, fieldInputType, validate,initialValue.toString());
  //       }
  //     }
  //   }
  // }

  validateErrors(key, label, fieldInputType, validate, value) {
    _register(
        key: key,
        valid:
            generalValidator(value, label, fieldInputType, validate) == null);
  }

  String? _validateServiceNumber(String? value) {
    RegExp regExp = RegExp('^(mt|MT|p|P|mtm|MTM|pw|PW)[ ]([0-9])');
    if (isInputNull(value) || value!.isEmpty) {
      return 'Service Number must be provided';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid Service Number';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    RegExp regExp = RegExp(r'^0([0-9]{9})$');
    if (isInputNull(value) || value!.isEmpty) {
      return 'Mobile Number must be provided';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid Mobile number';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (isInputNull(value) || value!.isEmpty) {
      return 'Full Name must be provided';
    }
    if (!value.contains(RegExp(
        r"[A-Z][a-zA-Z]{2,15}\s[A-Z][a-zA-Z]{2,15}\s[A-Z][a-zA-Z]{2,15}"))) {
      return "Three names starting with Capital letter are required";
    }
    return null;
  }

  String? _validateNormalFields(dynamic value, validateName) {
    if (isInputNull(value) || value.isEmpty) {
      return '$validateName must be provided';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (isInputNull(value) || value!.isEmpty) {
      return 'Email must be provided';
    }
    if (!value
        .contains(RegExp(r"[a-z0-9]{2,15}[@][a-z]{2,15}[.][a-z]{2,15}"))) {
      return 'Invalid Email provided';
    }
    return null;
  }

  String? generalValidator(dynamic value, String? validateName,
      FieldInputType? fieldInputType, bool? validate) {
    if (fieldInputType == FieldInputType.MobileNumber && validate!) {
      return _validateMobileNumber(value);
    } else if (fieldInputType == FieldInputType.FullName && validate!) {
      return _validateFullName(value);
    } else if (fieldInputType == FieldInputType.ServiceNumber && validate!) {
      return _validateServiceNumber(value);
    } else if (fieldInputType == FieldInputType.EmailAddress && validate!) {
      return _validateEmail(value);
    } else if (validate!) {
      return _validateNormalFields(value, validateName);
    }
    return null;
  }

  _register({required String key, required bool valid}) {
    _validationMap[key] = valid;
    hasErrors = _validationMap.values.any((value) => !value);
    hasError.value = hasErrors;
  }
}

enum FieldInputType {
  UpperCase,
  AttachmentField,
  AttachmentButton,
  MobileNumber,
  DigitOnly,
  Currency,
  ServiceNumber,
  FullName,
  EmailAddress,
  Other
}

enum WidthSize {
  col12,
  col11,
  col10,
  col9,
  col8,
  col7,
  col6,
  col5,
  col4,
  col3,
  col2,
  col1
}

class CustomDisplayKey {
  final String titleDisplayLabelKey;
  final String? subtitleDisplayLabelKey;
  final String inputValueField;
  const CustomDisplayKey(
      {this.titleDisplayLabelKey = 'name',
      this.subtitleDisplayLabelKey,
      this.inputValueField = 'uid'});
}

class UpdateField {
  static UpdateField? _instance;
  static getInstance() {
    if (_instance == null) {
      return _instance = UpdateField();
    }
    return _instance!;
  }

  // Box? box;
  // Future<Box> init() async {
  //   return await Hive.openBox('fieldsBox');
  // }
}

class FieldController {
  TextInput? _instance;
  bool hasErrors = true;
  static TextInput? _textInputnstance;
  List<Map<String, dynamic>> _values = [];
  // List<Map<String, dynamic>> _storage = [];
  List<Map<String, dynamic>> updateFieldList = [];

  ///Creating a SingleTon of [TextInput]
  static TextInput _use() {
    _textInputnstance ??= TextInput(
        fieldController: FieldController(),
        fieldValuesController: FieldValuesController());
    return _textInputnstance!;
  }

  ///Clearing the Instance
  void clearFields() {
    _textInputnstance = null;
  }

  ///Returning a single instance of [TextInput]
  static TextInput get use => _use();

  TextInput get field {
    _instance ??= TextInput(
        fieldController: this, fieldValuesController: FieldValuesController());
    return _instance!;
  }

  void setValue(List<Map<String, dynamic>>? value) {
    value ??= [];
    _values = SettingsService.use.updateListWithNoDublicate(_values, value);
  }

  void addValue(dynamic value) => _values.add(value);

  List<Map<String, dynamic>> get instanceValues => _values;

  // List<Map<String, dynamic>> get updateStorage => _storage;

  updateValue(dynamic value, String key, int index) {
    if (value is String && value.isEmpty || value == null) {
      _values.removeAt(index);
      return;
    }
    if (index != -1) _values[index].update(key, (x) => value);
  }

  // Stream controller and stream for field updates
  final _fieldUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get fieldUpdates =>
      _fieldUpdateController.stream;

  // Method to update field and notify listeners
  void updateField(List<Map<String, dynamic>> fieldData) {
    // updateFieldList = fieldData;
    _fieldUpdateController.add({'hasErrors': hasErrors, 'data': fieldData});
  }

  dispose() {
    _fieldUpdateController.close();
  }
}

class FieldValuesController {
  List<Map<String, dynamic>> _values = [];
  // List<Map<String, dynamic>> _storage = [];

  void clearInstance() {
    instanceValues.clear();
  }

  void setValue(List<Map<String, dynamic>>? value) {
    value ??= [];
    _values = SettingsService.use.isEmptyOrNull(instanceValues)
        ? value
        : SettingsService.use.updateListWithNoDublicate(_values, value);
  }

  void addValue(dynamic value) {
    _values.add(value);
  }

  List<Map<String, dynamic>> get instanceValues => _values;
  set instanceValues(value) => _values = value;

  // List<Map<String, dynamic>> get updateStorage => _storage;

  updateValue(dynamic value, String key, int index) {
    if (value is String && value.isEmpty || value == null) {
      _values.removeAt(index);
      return;
    }
    _values[index].update(key, (x) => value);
  }
}

ValueNotifier<bool> hasError = ValueNotifier(true);
