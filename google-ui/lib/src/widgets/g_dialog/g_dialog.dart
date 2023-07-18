import 'package:flutter/material.dart';

import '../g_text_button/g_text_button.dart';

/// Display a dialog.
class GDialog {
  /// A dialog that is usually displayed asking the user to confirm before taking an action.
  static void showConfirmation(
    BuildContext context, {
    required String title,
    required String subtitle,
    String confirmLabel = "Ok",
    String cancelLabel = "Cancel",
    required void Function()? onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            GTextButton(
              cancelLabel,
              onPressed: () => Navigator.of(context).pop(),
            ),
            GTextButton(
              confirmLabel,
              onPressed: onConfirm,
            ),
          ],
        );
      },
    );
  }

  /// A dialog that is usually displayed to display an alert message.
  static void showAlert(
    BuildContext context, {
    required String title,
    required String subtitle,
    String confirmLabel = "Ok",
    void Function()? onConfirm,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            GTextButton(
              confirmLabel,
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) onConfirm();
              },
            )
          ],
        );
      },
    );
  }
}
