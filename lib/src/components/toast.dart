import 'dart:math';


import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);

class Toast {
   static BuildContext? _context;
  static init(context){
    _context = context;
  }
  static void info(String message) {
    ToastViewContainer.show(ToastViewContainer.INFO, message, _context!);
  }

  static void warn(String message) {
    ToastViewContainer.show(ToastViewContainer.WARN, message, _context!);
  }

  static void error(String message) {
    ToastViewContainer.show(ToastViewContainer.ERROR, message, _context!);
  }
}

class ToastViewContainer {
  static final ToastViewContainer _singleton = ToastViewContainer._internal();

  factory ToastViewContainer() {
    return _singleton;
  }

  ToastViewContainer._internal();

  static const int INFO = 0;
  static const int WARN = 1;
  static const int ERROR = 2;
  static int count = 0;
  static OverlayState? overlayState;
  static OverlayEntry? overlayEntry;
  static List<ToastWidgetHolder> widgets = [];
  static Future<void> show(
      int type, String message, BuildContext context) async {
    String id = Random.secure().nextDouble().toString();
    widgets.add(ToastWidgetHolder(
        id: id,
        widget: ToastView.createView(type, message, dismiss,
            id))); // pos, ToastView.createView(type, message, dismiss, pos)});
    overlayState ??= Overlay.of(context);
    addEntry();
    await Future.delayed(const Duration(seconds: 3));
    dismiss(id);
  }

  static void addEntry() {
    if (overlayEntry != null) overlayEntry!.remove();
    overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets.map((e) => e.widget).toList(),
            )));
    overlayState!.insert(overlayEntry!);
  }

  static void dismiss(String index) {
    late ToastWidgetHolder toRemove;
    for (var widget in widgets) {
      if (widget.id == index) toRemove = widget;
    }
    widgets.remove(toRemove);
    addEntry();
  }
}

class ToastView {
  static Widget createView(
      int type, String message, StringCallback onClose, String index) {
    Color bgColor = Colors.lightBlue;
    if (type == ToastViewContainer.WARN) {
      bgColor = Colors.orange;
    } else if (type == ToastViewContainer.ERROR) {
      bgColor = Colors.red;
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: bgColor),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Material(
          color: Colors.transparent,
          child: Text(message,
              softWrap: true,
              style: const TextStyle(fontSize: 18, color: Colors.white))),
    );
  }
}

class ToastWidgetHolder {
  ToastWidgetHolder({required this.id, required this.widget});

  String id;
  Widget widget;
}
