import 'package:flutter/material.dart';

/// Change [selectionHandleColor] for [TextFormField].
/// Note [selectionHandleColor] only changed on first build.
///
/// This is a workaround for https://github.com/flutter/flutter/issues/74890.
///
/// See https://github.com/flutter/flutter/issues/74890#issuecomment-901169865.
class GTextSelectionControls extends TextSelectionControls {
  GTextSelectionControls(this.handleColor);

  final Color handleColor;
  final TextSelectionControls _controls = materialTextSelectionControls;

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(selectionHandleColor: handleColor),
      child: Builder(
        builder: (context) => _controls.buildHandle(
          context,
          type,
          textLineHeight,
        ),
      ),
    );
  }

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset position,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier? clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    return _controls.buildToolbar(
        context,
        globalEditableRegion,
        textLineHeight,
        position,
        endpoints,
        delegate,
        clipboardStatus,
        lastSecondaryTapDownPosition);
  }

  @override
  Offset getHandleAnchor(
    TextSelectionHandleType type,
    double textLineHeight, [
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    return _controls.getHandleAnchor(type, textLineHeight);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return _controls.getHandleSize(textLineHeight);
  }
}
