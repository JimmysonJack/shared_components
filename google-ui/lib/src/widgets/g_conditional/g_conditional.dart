import 'package:flutter/material.dart';

/// Display a widget based on condition.
class GConditional extends StatelessWidget {
  const GConditional({
    Key? key,
    required this.condition,
    required this.onTrue,
    required this.onFalse,
  }) : super(key: key);

  /// A condition to display widget [onTrue] or [onFalse].
  final bool condition;

  /// A widget that display if [condition] true.
  final Widget onTrue;

  /// A widget that display if [condition] false.
  final Widget onFalse;

  @override
  Widget build(BuildContext context) {
    if (condition) return onTrue;
    return onFalse;
  }

  static Widget? isTrue({required bool condition, required Widget onTrue}) =>
      condition ? onTrue : null;
}
