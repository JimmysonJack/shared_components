import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget altinateChild;

  const Conditional(
      {super.key,
      required this.condition,
      required this.child,
      required this.altinateChild});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Offstage(
          offstage: condition,
          child: child,
        ),
        Offstage(
          offstage: !condition,
          child: altinateChild,
        ),
      ],
    );
  }
}
