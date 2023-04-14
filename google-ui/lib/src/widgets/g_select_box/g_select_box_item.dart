import 'package:flutter/material.dart';

/// Create a select box item.
class GSelectBoxItem<T> {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final T value;

  GSelectBoxItem({
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
  });

  GSelectBoxItem<T> copyWith({
    String? title,
    String? subtitle,
    Widget? icon,
    T? value,
  }) {
    return GSelectBoxItem<T>(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      value: value ?? this.value,
    );
  }
}
