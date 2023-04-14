
import 'package:flutter/material.dart';

class Tabs {
  final String url;
  final String title;
  final Widget page;
  final bool permission;

  Tabs({required this.url, required this.title, required this.page,this.permission = false});

}