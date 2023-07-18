import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';

import '../../themes/theme.dart';

class BodyWidget extends StatelessWidget {
  final String columnName;
  final String columnValue;
  const BodyWidget(
      {super.key, required this.columnName, required this.columnValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GText(
            columnName,
            color: ThemeController.getInstance().darkMode(
                darkColor: Colors.white30, lightColor: Colors.black38),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GText(
            columnValue,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          endIndent: 30,
          indent: 30,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
