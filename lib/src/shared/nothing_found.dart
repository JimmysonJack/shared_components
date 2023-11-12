import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GText(
        'Nothing Found',
        fontWeight: FontWeight.bold,
        color: Theme.of(context).disabledColor,
      ),
    );
  }
}
