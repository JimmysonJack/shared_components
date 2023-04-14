import 'package:flutter/material.dart';

import 'g_text_variant.dart';

/// Create a text.
class GText extends StatelessWidget {
  const GText(
    this.text, {
    Key? key,
    this.variant = GTextVariant.bodyText2,
    this.textAlign,
    this.color,
    this.colorBuilder,
    this.textOverflow,
    this.maxLines,
    this.softWrap,
    this.fontSize,
    this.fontWeight,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
  }) : super(key: key);

  /// Text to display.
  final String text;

  /// Set text variant.
  final GTextVariant variant;

  /// Set text align.
  final TextAlign? textAlign;

  /// Set text color.
  final Color? color;

  /// Set text color using colorBuilder
  final Color? Function(ColorScheme)? colorBuilder;

  /// Set text overflow.
  final TextOverflow? textOverflow;

  /// Set max lines.
  final int? maxLines;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// Set font size.
  final double? fontSize;

  /// Set font weight.
  final FontWeight? fontWeight;

  /// Set text decoration
  final TextDecoration? decoration;

  /// Set text decoration color
  final Color? decorationColor;

  /// Set text decoration style
  final TextDecorationStyle? decorationStyle;

  /// Set text decoration thickness
  final double? decorationThickness;

  TextStyle _textStyle(BuildContext context) {
    switch (variant) {
      case GTextVariant.headline1:
        return Theme.of(context).textTheme.headline1!;

      case GTextVariant.headline2:
        return Theme.of(context).textTheme.headline2!;

      case GTextVariant.headline3:
        return Theme.of(context).textTheme.headline3!;

      case GTextVariant.headline4:
        return Theme.of(context).textTheme.headline4!;

      case GTextVariant.headline5:
        return Theme.of(context).textTheme.headline5!;

      case GTextVariant.headline6:
        return Theme.of(context).textTheme.headline6!;

      case GTextVariant.subtitle1:
        return Theme.of(context).textTheme.subtitle1!;

      case GTextVariant.subtitle2:
        return Theme.of(context).textTheme.subtitle2!;

      case GTextVariant.bodyText1:
        return Theme.of(context).textTheme.bodyText1!;

      case GTextVariant.bodyText2:
        return Theme.of(context).textTheme.bodyText2!;

      case GTextVariant.button:
        return Theme.of(context).textTheme.button!;

      case GTextVariant.caption:
        return Theme.of(context).textTheme.caption!;

      case GTextVariant.overline:
        return Theme.of(context).textTheme.overline!;

      default:
        return Theme.of(context).textTheme.bodyText1!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        color ?? colorBuilder?.call(Theme.of(context).colorScheme);

    return Text(
      text,
      style: _textStyle(context).copyWith(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      ),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
