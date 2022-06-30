import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'custom_text_field_store.dart';
// import 'package:xagent/app/shared/textField/custom_text_field_store.dart';

class CustomTextField extends StatefulWidget {
   const CustomTextField({Key? key, required this.hintText, this.enabled = true, this.keyboardType, this.onChanged, this.inputFormatters, required this.validator, this.controller,}) : super(key: key);
  final String hintText;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value) validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ModularState<CustomTextField, CustomTextStore> {

   FocusNode focusNode = FocusNode();

   @override
   Widget build(BuildContext context) {
     return TextFormField(
       autovalidateMode: AutovalidateMode.onUserInteraction,
       focusNode: focusNode,
       controller: widget.controller ?? TextEditingController(),
       textCapitalization: TextCapitalization.sentences,
       inputFormatters: widget.inputFormatters ?? [],
       validator: widget.validator,
       decoration: InputDecoration(
         hintText: widget.hintText,
       ),
       keyboardType: widget.keyboardType ?? TextInputType.text,
       enabled: widget.enabled,
       onChanged: (value){
         store.fieldValue = value;
         widget.onChanged == null ? (){} : widget.onChanged!(value) ;
       },
     );
   }
}

