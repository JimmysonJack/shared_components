import 'package:flutter/material.dart';

class SideMenuController {
  late void Function() open;
  late void Function() close;
  late void Function() toggle;
}

enum ToggleState { opened, closed, nothing }

class ToggleController extends ValueNotifier<ToggleState> {
  ToggleController(super.value);

  void toggle(ToggleState toggleState) {
    value = toggleState;
    notifyListeners();
  }
}
