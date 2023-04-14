import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../g_text_form_field/g_text_form_field.dart';

/// Create a date text form field.
class GDateTextFormField extends StatelessWidget {
  const GDateTextFormField({
    Key? key,
    this.labelText,
    this.initialValue,
    this.controller,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.readOnly = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.inputFormatters,
    this.primaryColor,
    this.primaryColorBuilder,
    this.textColor,
    this.textColorBuilder,
    this.cursorColor,
    this.cursorColorBuilder,
  }) : super(key: key);

  /// Text that describes the input field.
  final String? labelText;

  /// The initial value of [GDateTextFormField].
  final DateTime? initialValue;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// An action the user has requested the text input control to perform.
  final TextInputAction? textInputAction;

  /// A callback after this field value changed.
  final void Function(DateTime? value)? onChanged;

  /// A callback after form [save()] called.
  final void Function(DateTime? value)? onSaved;

  /// A callback after the user tap this widget.
  final void Function()? onTap;

  /// If true, set this field as read only.
  final bool readOnly;

  /// Enable or disable auto correct.
  final bool autocorrect;

  /// Enable or disable auto focus.
  final bool autofocus;

  /// A widget to display after the input area.
  final Widget? suffixIcon;

  /// A widget to display before the input area.
  final Widget? prefixIcon;

  /// A callback after form [validate()] called.
  final String? Function(String? value, bool isValid)? validator;

  /// Input formatter.
  final List<TextInputFormatter>? inputFormatters;

  /// Set primary color.
  final Color? primaryColor;

  /// Set primary color using colorBuilder
  final Color? Function(ColorScheme)? primaryColorBuilder;

  /// Set [hintText] and [Text] color.
  final Color? textColor;

  /// Set text color using colorBuilder
  final Color? Function(ColorScheme)? textColorBuilder;

  /// The default color for [cursorColor], [selectionHandleColor] and [selectionColor].
  /// Note [selectionHandleColor] only changed on first build.
  final Color? cursorColor;

  /// Set cursor color using colorBuilder
  final Color? Function(ColorScheme)? cursorColorBuilder;

  @override
  Widget build(BuildContext context) {
    const datePattern = r"^(0[1-9]|[12]\d|30|31)\/(0[1-9]|1[0-2])\/(\d{4})$";
    final dateDefaultValue = initialValue != null
        ? DateFormat('dd/MM/yyyy').format(initialValue!)
        : null;

    return GTextFormField(
      labelText: labelText,
      primaryColor: primaryColor,
      primaryColorBuilder: primaryColorBuilder,
      textColor: textColor,
      textColorBuilder: textColorBuilder,
      cursorColor: cursorColor,
      cursorColorBuilder: cursorColorBuilder,
      autocorrect: autocorrect,
      autofocus: autofocus,
      hintText: "DD/MM/YYYY",
      initialValue: dateDefaultValue,
      keyboardType: TextInputType.datetime,
      textInputAction: textInputAction,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(getDateTimeFromString(datePattern, value));
        }
      },
      onSaved: (value) {
        if (value != null && onSaved != null) {
          onSaved!(getDateTimeFromString(datePattern, value));
        }
      },
      onTap: onTap,
      readOnly: readOnly,
      maxLength: 10,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      validator: (value) {
        bool isValid = true;
        if (!(value == null || value.trim() == '')) {
          isValid = RegExp(datePattern).hasMatch(value);
        }
        if (validator != null) return validator!(value, isValid);
        return null;
      },
      inputFormatters: inputFormatters,
    );
  }

  DateTime? getDateTimeFromString(String datePattern, String value) {
    DateTime? date;
    final isValid = RegExp(datePattern).hasMatch(value);
    if (isValid) {
      final splitValue = value.split('/');
      final newValue = '${splitValue[2]}${splitValue[1]}${splitValue[0]}';

      date = DateTime.parse(newValue);
    }

    return date;
  }
}
