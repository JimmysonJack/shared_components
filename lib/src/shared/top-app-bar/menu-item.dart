import 'package:flutter/material.dart';

class MenuItem<T> {
  final String title;
  final IconData icon;
  final T value;
  MenuItem({required this.title, required this.icon, required this.value});
}
