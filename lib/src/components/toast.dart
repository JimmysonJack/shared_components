import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);

class Toast {
  static BuildContext? _context;
  static init(context) {
    _context = context;
  }

  static void info(String title, {String? subTitle,bool? strip}) {
    ToastViewContainer.show(
        ToastViewContainer.INFO, title, _context!, subTitle,strip);
  }

  static void warn(String title, {String? subTitle,bool? strip}) {
    ToastViewContainer.show(
        ToastViewContainer.WARN, title, _context!, subTitle,strip);
  }

  static void error(String title, {String? subTitle,bool? strip}) {
    ToastViewContainer.show(
        ToastViewContainer.ERROR, title, _context!, subTitle,strip);
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
      int type, String message, BuildContext context, String? content, bool? strip) async {
    String id = Random.secure().nextDouble().toString();
    widgets.add(ToastWidgetHolder(
        id: id,
        widget: ToastView.createView(type, message, dismiss, id, context,
            content, strip))); // pos, ToastView.createView(type, message, dismiss, pos)});
    overlayState ??= Overlay.of(context);
    addEntry();
    await Future.delayed(const Duration(seconds: 6));
    dismiss(id);
  }

  static void addEntry() {
    if (overlayEntry != null) overlayEntry!.remove();
    overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
            top: 4,
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
  static Widget createView(int type, String message, StringCallback onClose,
      String index, BuildContext context, String? content, bool? strip) {
    Color bgColor = Colors.green;
    IconData bgIcon = Icons.task_alt;
    strip ??= false;
    if (type == ToastViewContainer.WARN) {
      bgColor = Colors.orange;
      bgIcon = Icons.error_outline;
    } else if (type == ToastViewContainer.ERROR) {
      bgColor = Colors.red;
      bgIcon = Icons.cancel_outlined;
    }
    return Container(
      decoration: BoxDecoration(
        color: strip ? Colors.white : bgColor,
        // borderRadius: BorderRadius.circular(0),
        border: strip
            ? Border(
                left: BorderSide(
                  width: 10,
                  color: bgColor,
                ),
                top: BorderSide(
                  width: 2,
                  color: bgColor,
                ),
                right: BorderSide(
                  width: 2,
                  color: bgColor,
                ),
                bottom: BorderSide(
                  width: 2,
                  color: bgColor,
                ))
            : Border.all(color: bgColor),
      ),
      constraints:
          BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.2),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(
                bgIcon,
                color: strip ? bgColor: Theme.of(context).cardColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16, color: strip ? Theme.of(context).hintColor : Theme.of(context).cardColor)),
                  // if(content != null) const SizedBox(height: 10,),
                  if (content != null)
                    Text(content,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 12, color: strip ? Theme.of(context).hintColor : Theme.of(context).cardColor)),
                ],
              ),
            ],
          )),
    );
  }
}

class ToastWidgetHolder {
  ToastWidgetHolder({required this.id, required this.widget});

  String id;
  Widget widget;
}
