import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'custom_text_field_store.dart';
// import 'package:xagent/app/shared/textField/custom_text_field_store.dart';

class CustomTextField extends StatefulWidget {
   const CustomTextField({Key? key,this.updateEntry,this.obscure = false, required this.hintText, this.enabled = true, this.keyboardType, this.onChanged, this.inputFormatters, required this.validator, this.controller,}) : super(key: key);
  final String hintText;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value) validator;
  final String? updateEntry;
  final bool obscure;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  void initState() {
    ///it inserts value to [TextFormField] during updating process
    widget.controller?.text = widget.updateEntry ?? '';

    ///when the values are inserted in a [TextFormField], validator is called to validate the inserted data
    widget.validator(widget.updateEntry);
    super.initState();
  }

   FocusNode focusNode = FocusNode();

   @override
   Widget build(BuildContext context) {
     return TextFormField(
       autovalidateMode: AutovalidateMode.onUserInteraction,
       focusNode: focusNode,
       obscureText: widget.obscure,
       controller: widget.controller ?? TextEditingController(),
       textCapitalization: TextCapitalization.sentences,
       inputFormatters: widget.inputFormatters ?? [],
       validator: widget.validator,
       decoration: InputDecoration(
         hintText: widget.hintText,
         filled: true,
         fillColor: Theme.of(context).cardColor
       ),
       keyboardType: widget.keyboardType ?? TextInputType.text,
       enabled: widget.enabled,
       onChanged: (value){
         widget.onChanged == null ? (){} : widget.onChanged!(value) ;
       },
     );
   }
}

