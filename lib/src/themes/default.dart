import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor defaultDark = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff009788), //10%
      100: Color(0xff00887a), //20%
      200: Color(0xff00796d), //30%
      300: Color(0xff005b52), //40%
      400: Color(0xff004c44), //50%
      500: Color(0xff003c36), //60%
      600: Color(0xff002d29), //70%
      700: Color(0xff001e1b), //80%
      800: Color(0xff000f0e), //90%
      900: Color(0xff000000), //100%
    },
  );

  static const MaterialColor defaultLight = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff009788), //10%
      100: Color(0xff1aa194), //20%
      200: Color(0xff33aca0), //30%
      300: Color(0xff66c1b8), //40%
      400: Color(0xff80cbc4), //50%
      500: Color(0xff99d5cf), //60%
      600: Color(0xffb3e0db), //70%
      700: Color(0xffcceae7), //80%
      800: Color(0xffe6f5f3), //90%
      900: Color(0xffffffff), //100%
    },
  );

  static const MaterialColor textLight = MaterialColor(
    0xff808080, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff737373), //10%
      100: Color(0xff666666), //20%
      200: Color(0xff5a5a5a), //30%
      300: Color(0xff4d4d4d), //40%
      400: Color(0xff404040), //50%
      500: Color(0xff333333), //60%
      600: Color(0xff262626), //70%
      700: Color(0xff1a1a1a), //80%
      800: Color(0xff0d0d0d), //90%
      900: Color(0xff000000), //100%
    },
  );

  static const MaterialColor textDark = MaterialColor(
    0xff808080, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff8d8d8d), //10%
      100: Color(0xff999999), //20%
      200: Color(0xffa6a6a6), //30%
      300: Color(0xffb3b3b3), //40%
      400: Color(0xffc0c0c0), //50%
      500: Color(0xffcccccc), //60%
      600: Color(0xffd9d9d9), //70%
      700: Color(0xffe6e6e6), //80%
      800: Color(0xfff2f2f2), //90%
      900: Color(0xffffffff), //100%
    },
  );

  static const MaterialColor shadeDark = MaterialColor(
    0xff808080, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff737373), //10%
      100: Color(0xff666666), //20%
      200: Color(0xff5a5a5a), //30%
      300: Color(0xff4d4d4d), //40%
      400: Color(0xff404040), //50%
      500: Color(0xff333333), //60%
      600: Color(0xff262626), //70%
      700: Color(0xff1a1a1a), //80%
      800: Color(0xff0d0d0d), //90%
      900: Color(0xff000000), //100%
    },
  );

  static const MaterialColor shadeLight = MaterialColor(
    0xff808080, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff8d8d8d), //10%
      100: Color(0xff999999), //20%
      200: Color(0xffa6a6a6), //30%
      300: Color(0xffb3b3b3), //40%
      400: Color(0xffc0c0c0), //50%
      500: Color(0xffcccccc), //60%
      600: Color(0xffd9d9d9), //70%
      700: Color(0xffe6e6e6), //80%
      800: Color(0xfff2f2f2), //90%
      900: Color(0xffffffff), //100%
    },
  );
}
