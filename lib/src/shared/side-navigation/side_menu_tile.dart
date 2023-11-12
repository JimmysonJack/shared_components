import 'package:flutter/material.dart';

class SideMenuTile {
  final String title;
  final IconData icon;
  final String? tooltip;
  final String? badgeContent;
  final String url;
  final List<String> permissions;
  SideMenuTile(
      {required this.title,
      required this.icon,
      required this.url,
      this.tooltip,
      this.badgeContent,
      required this.permissions});
}
