import 'package:flutter/material.dart';

String currencyFormatter(amount) {
  final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  // mathFunc(Match match) => '${match[1]},';

  return amount == null
      ? '0'
      : amount
          .toString()
          .replaceAllMapped(reg, (Match match) => '${match[1]},');
}

Widget textCurrency({required String? amount, TextStyle? style}) {
  final currencyStyle =
      style ?? const TextStyle(); // Use an empty style if style is null
  final currencyText = Text(
    currencyFormatter(amount == 'null' || amount == null ? '0' : amount),
    style: currencyStyle,
  );

  final currencySymbolText = Text(
    'Tsh',
    style: currencyStyle.copyWith(
        fontSize: currencyStyle.fontSize == null
            ? (14 * 0.5)
            : currencyStyle.fontSize! * 0.5),
  );

  return IntrinsicWidth(
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        currencyText,
        const SizedBox(width: 2), // Add some spacing between the texts
        if (amount != null || amount != 'null')
          Padding(
            padding: EdgeInsets.only(
                bottom: (currencyStyle.fontSize == null
                        ? ((14 * 0.5) * 0.20)
                        : currencyStyle.fontSize! * 0.5) *
                    0.20),
            child: currencySymbolText,
          ),
      ],
    ),
  );
}



// Widget textCurrency({required String amount, TextStyle? style}) {
//   return LayoutBuilder(builder: (context, constraint) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           currencyFormatter(amount),
//           style: style,
//         ),
//         Text(
//           'Tsh',
//           style: style == null
//               ? TextStyle(fontSize: constraint.maxHeight * 0.5)
//               : style.copyWith(fontSize: constraint.maxHeight * 0.5),
//         )
//       ],
//     );
//   });
// }
