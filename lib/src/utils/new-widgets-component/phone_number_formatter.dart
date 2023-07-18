import 'package:flutter/services.dart';

/// Format incoming numeric text to fit the format of (###) ###-#### ##
class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength == 1) {
      newText.write('+255 ');
      if (newValue.selection.end >= 1) selectionIndex += 5;
    }
    //    if (newTextLength >= 4) {
    //   newText.write('${newValue.text}');
    //   if (newValue.selection.end >= 1) selectionIndex++;
    // }
    // if (newTextLength >= 4) {
    //   newText.write('${newValue.text.substring(0, usedSubstringIndex = 3)} ');
    //   if (newValue.selection.end >= 4) selectionIndex += 2;
    // }
    // if (newTextLength >= 7) {
    //   newText.write('${newValue.text.substring(3, usedSubstringIndex = 6)}-');
    //   if (newValue.selection.end >= 6) selectionIndex++;
    // }
    // if (newTextLength >= 11) {
    //   newText.write('${newValue.text.substring(6, usedSubstringIndex = 10)} ');
    //   if (newValue.selection.end >= 10) selectionIndex++;
    // }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}