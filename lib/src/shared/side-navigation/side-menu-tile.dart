import 'package:flutter/material.dart';

class SideMenuTile {
  final String title;
  final IconData icon;
  final String? tooltip;
  final String? badgeContent;
  final List<String> permissions;
  SideMenuTile(
      {required this.title,
      required this.icon,
      this.tooltip,
      this.badgeContent,
      required this.permissions});
}
