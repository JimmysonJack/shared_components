import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_component/src/components/toast.dart';

class NotificationService {
  static Future<bool> confirmInfo(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Color? buttonColor,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      String? content,
      Function()? onConfirmBtnTap}) async {
    return (await QuickAlert.show(
            context: context,
            barrierDismissible: false,
            cancelBtnText: cancelBtnText ?? '',
            confirmBtnText: confirmBtnText ?? '',
            confirmBtnColor: buttonColor ?? Theme.of(context).primaryColor,
            onCancelBtnTap: onCancelBtnTap,
            borderRadius: 0,
            onConfirmBtnTap: onConfirmBtnTap,
            showCancelBtn: showCancelBtn,
            title: title,
            text: content,
            width: MediaQuery.of(context).size.width * 0.2,
            type: QuickAlertType.info) ??
        false);
  }

  static Future confirmWarn(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Color? buttonColor,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      String? content,
      Function()? onConfirmBtnTap}) async {
    return (await QuickAlert.show(
        context: context,
        barrierDismissible: false,
        cancelBtnText: cancelBtnText ?? 'Cancel',
        confirmBtnText: confirmBtnText ?? 'Okay',
        confirmBtnColor: buttonColor ?? Theme.of(context).primaryColor,
        onCancelBtnTap: onCancelBtnTap,
        onConfirmBtnTap: onConfirmBtnTap,
        showCancelBtn: showCancelBtn,
        title: title,
        text: content,
        borderRadius: 0,
        width: MediaQuery.of(context).size.width * 0.2,
        type: QuickAlertType.warning));
  }

  static Future<bool> confirm(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Color? buttonColor,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      String? content,
      Function()? onConfirmBtnTap}) async {
    return (await QuickAlert.show(
            context: context,
            barrierDismissible: false,
            cancelBtnText: cancelBtnText ?? '',
            confirmBtnText: confirmBtnText ?? '',
            confirmBtnColor: buttonColor ?? Theme.of(context).primaryColor,
            onCancelBtnTap: onCancelBtnTap,
            onConfirmBtnTap: onConfirmBtnTap,
            showCancelBtn: showCancelBtn,
            title: title,
            text: content,
            borderRadius: 0,
            width: MediaQuery.of(context).size.width * 0.2,
            type: QuickAlertType.confirm) ??
        false);
  }

  static Future<bool> confirmError(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Color? buttonColor,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      String? content,
      Function()? onConfirmBtnTap}) async {
    return (await QuickAlert.show(
            context: context,
            barrierDismissible: false,
            cancelBtnText: cancelBtnText ?? '',
            confirmBtnText: confirmBtnText ?? '',
            confirmBtnColor: buttonColor ?? Theme.of(context).primaryColor,
            onCancelBtnTap: onCancelBtnTap,
            onConfirmBtnTap: onConfirmBtnTap,
            showCancelBtn: showCancelBtn,
            title: title,
            text: content,
            borderRadius: 0,
            width: MediaQuery.of(context).size.width * 0.2,
            type: QuickAlertType.error) ??
        false);
  }

  static Future<bool> confirmSuccess(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Color? buttonColor,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      String? content,
      Function()? onConfirmBtnTap}) async {
    return (await QuickAlert.show(
            context: context,
            barrierDismissible: false,
            cancelBtnText: cancelBtnText ?? '',
            confirmBtnText: confirmBtnText ?? '',
            confirmBtnColor: buttonColor ?? Theme.of(context).primaryColor,
            onCancelBtnTap: onCancelBtnTap,
            onConfirmBtnTap: onConfirmBtnTap,
            showCancelBtn: showCancelBtn,
            title: title,
            text: content,
            borderRadius: 0,
            width: MediaQuery.of(context).size.width * 0.2,
            type: QuickAlertType.success) ??
        false);
  }

  static snackBarError(
      {required BuildContext context,
      required String title,
      String? subTitle,
      bool? strip}) async {
    Toast.init(context);
    Toast.error(title, subTitle: subTitle, strip: strip);
  }

  static snackBarSuccess(
      {required BuildContext context,
      required String title,
      String? subTitle,
      bool? strip}) async {
    Toast.init(context);
    Toast.info(title, subTitle: subTitle, strip: strip);
  }

  static snackBarWarn(
      {required BuildContext context,
      required String title,
      String? subTitle,
      bool? strip}) async {
    Toast.init(context);
    Toast.warn(title, subTitle: subTitle, strip: strip);
  }

  static Future<bool> info(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      String? content,
      Function()? onConfirmBtnTap}) async {
    return (await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Container(
          constraints: BoxConstraints(
            // minWidth: MediaQuery.of(context).size.width * 0.2,
            maxWidth: MediaQuery.of(context).size.width * 0.23,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
                child: Text(
                  content ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Theme.of(context).highlightColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonTheme(
                      data: const TextButtonThemeData(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll<Color>(
                                  Colors.transparent))),
                      child: TextButton(
                        onPressed: () =>
                            onConfirmBtnTap ??
                            Navigator.of(context).pop(true), // <-- SEE HERE
                        child: Text(confirmBtnText ?? 'Yes'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (showCancelBtn)
                      TextButtonTheme(
                        data: const TextButtonThemeData(
                            style: ButtonStyle(
                                overlayColor: MaterialStatePropertyAll<Color>(
                                    Colors.transparent))),
                        child: TextButton(
                          onPressed: () =>
                              onCancelBtnTap ??
                              Navigator.of(context).pop(false), //<-- SEE HERE
                          child: Text(
                            cancelBtnText ?? 'No',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  static Future<bool> errors(
      {required BuildContext context,
      String? cancelBtnText,
      String? confirmBtnText,
      Function()? onCancelBtnTap,
      bool showCancelBtn = false,
      String? title,
      required List contents,
      Function()? onConfirmBtnTap}) async {
    return (await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Container(
          constraints: BoxConstraints(
            // minWidth: MediaQuery.of(context).size.width * 0.2,
            maxWidth: MediaQuery.of(context).size.width * 0.23,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                      contents.length,
                      (index) => Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          width: 10,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error))),
                              child: Text(
                                contents.elementAt(index).message ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          )),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonTheme(
                      data: const TextButtonThemeData(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll<Color>(
                                  Colors.transparent))),
                      child: TextButton(
                        onPressed: () =>
                            onConfirmBtnTap ??
                            Navigator.of(context).pop(true), // <-- SEE HERE
                        child: Text(
                          confirmBtnText ?? 'Ok',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (showCancelBtn)
                      TextButtonTheme(
                        data: const TextButtonThemeData(
                            style: ButtonStyle(
                                overlayColor: MaterialStatePropertyAll<Color>(
                                    Colors.transparent))),
                        child: TextButton(
                          onPressed: () =>
                              onCancelBtnTap ??
                              Navigator.of(context).pop(false), //<-- SEE HERE
                          child: Text(
                            cancelBtnText ?? 'No',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
