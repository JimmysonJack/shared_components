
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_component/src/searchableTextField/searchTextFieldBase.dart';

class SearchTextField<T> extends StatefulWidget {
  const SearchTextField({
    Key? key,
    this.onTap,
    required this.onSelected,
    required this.validator,
    required this.accessTitleValueKey,
    this.accessDiscValueKey,
    this.labelText,
    this.borderRadius,
    this.focusBorder,
    this.initialValue,
    required this.controller,
    required this.hintText,
    required this.onChange,
    required this.isNetworkData,
    required this.findFn,
    this.enabled = true,
    this.filled = false,
    this.isChipInputs = false,
    this.subObject,
    this.updateEntry,
    this.chipList,
    this.objectTitle
  }) : super(key: key);
  final VoidCallback? onTap;
  final void Function(dynamic) onSelected;
  final String? Function(String? value) validator;
  final String accessTitleValueKey;
  final String? accessDiscValueKey;
  final String? labelText;
  final double? borderRadius;
  final double? focusBorder;
  final Map<String,dynamic>? initialValue;
  final TextEditingController controller;
  final Function(String value) onChange;
  final bool isNetworkData;
  final bool enabled;
  final bool filled;
  final bool isChipInputs;
  final String? subObject;
  final String? objectTitle;
  final String hintText;
  final List<Map<String,dynamic>>? chipList;
  final String? updateEntry;
  final Future<List<Map<String, dynamic>>> Function(String) findFn;

  @override
  SearchFieldCustomState createState() => SearchFieldCustomState<T>();
}

class SearchFieldCustomState<T> extends State<SearchTextField> {
  @override
  void dispose() {
    widget.controller.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SearchField(
      enabled: widget.enabled,
      updateEntry: widget.updateEntry,
      isChipInputs: widget.isChipInputs,
      chipList: widget.chipList ?? [],
      isNetworkData: widget.isNetworkData,
      findFn: widget.findFn,
      onTap: (value){
        widget.onSelected(value);
      },
      onChange: (item){
        widget.onChange(item);
      },
      titleKey: widget.accessTitleValueKey,
      objectTitleKey: widget.objectTitle,
      subObjectTitleKey: widget.subObject,
      subTitleKey: widget.accessDiscValueKey,
      controller: widget.controller,
      initialValue: widget.initialValue,
      suggestions: const [],
      hint: widget.hintText,
      validator: widget.validator,
      hasOverlay: true,
      suggestionAction: SuggestionAction.unfocus,
      textInputAction: TextInputAction.done,
      searchInputDecoration: InputDecoration(
          border: widget.filled == false ?  const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(
            //     widget.borderRadius == null ? 0 : widget.borderRadius!),
            borderSide: BorderSide(),
          ) : const OutlineInputBorder(
              borderSide: BorderSide.none
          ),
          filled: widget.filled,
          fillColor: Colors.black.withOpacity(0.2),
          focusedBorder: widget.filled == false ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.focusBorder == null ? 0 : widget.focusBorder!),
            borderSide: const BorderSide(color: Colors.black),
          ) : const OutlineInputBorder(
              borderSide: BorderSide.none
          ),
          isDense: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          labelText: widget.labelText),
    );
  }
}
