import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class Palette {
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }

  static MaterialColor defaultDark = MaterialColor(
    int.parse(
        '0xff${AppColors.appInstance().get.primary!}'), // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -1.0), //10%
      100: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.8), //20%
      200: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.6), //30%
      300: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.4), //40%
      400: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.2), //50%
      500: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.2), //60%
      600: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.4), //70%
      700: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.6), //80%
      800: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.8), //90%
      900: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 1.0), //100%
    },
  );

  static MaterialColor defaultLight = MaterialColor(
    int.parse(
        '0xff${AppColors.appInstance().get.primary!}'), // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 1.0), //10%
      100: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.8), //20%
      200: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.6), //30%
      300: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.4), //40%
      400: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), 0.2), //50%
      500: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.2), //60%
      600: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.4), //70%
      700: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.6), //80%
      800: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -0.8), //90%
      900: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.primary!), -1.0), //100%
    },
  );

  static MaterialColor textLight = MaterialColor(
    int.parse(
        '0xff${AppColors.appInstance().get.text!}'), // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 1.0), //10%
      100: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.8), //20%
      200: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.6), //30%
      300: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.4), //40%
      400: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.2), //50%
      500: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.2), //60%
      600: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.4), //70%
      700: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.6), //80%
      800: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.8), //90%
      900: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -1.0), //100%
    },
  );

  static MaterialColor textDark = MaterialColor(
    int.parse(
        '0xff${AppColors.appInstance().get.text!}'), // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -1.0), //10%
      100: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.8), //20%
      200: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.6), //30%
      300: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.4), //40%
      400: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), -0.2), //50%
      500: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.2), //60%
      600: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.4), //70%
      700: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.6), //80%
      800: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 0.8), //90%
      900: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.text!), 1.0), //100%
    },
  );

  static MaterialColor shadeDark = MaterialColor(
    int.parse(
        '0xff${AppColors.appInstance().get.shade!}'), // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -1.0), //10%
      100: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.8), //20%
      200: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.6), //30%
      300: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.4), //40%
      400: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.2), //50%
      500: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.2), //60%
      600: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.4), //70%
      700: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.6), //80%
      800: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.8), //90%
      900: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 1.0), //100%
    },
  );

  static MaterialColor shadeLight = MaterialColor(
    int.parse(
        '0xff${AppColors.appInstance().get.shade!}'), // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 1.0), //10%
      100: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.8), //20%
      200: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.6), //30%
      300: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.4), //40%
      400: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), 0.2), //50%
      500: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.2), //60%
      600: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.4), //70%
      700: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.6), //80%
      800: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -0.8), //90%
      900: AppColors.adjustBrightness(
          hexToColor(AppColors.appInstance().get.shade!), -1.0), //100%
    },
  );
}

class AppColors {
  static AppColors? _instance;
  String? primary;
  String? text;
  String? shade;
  AppColors({this.primary, this.text, this.shade});

  static Color adjustBrightness(Color color, double factor) {
    ///Make sure the factor is between -1.0 and 1.0
    factor = factor.clamp(-1.0, 1.0);

    ///Convert the color to HLS(Hue, Satuation, Lightness)
    final HSLColor hslColor = HSLColor.fromColor(color);

    ///Modefy the lightness
    final HSLColor adjustedHslColor =
        hslColor.withLightness((hslColor.lightness + factor).clamp(0.0, 1.0));

    ///Convert back to RGB
    return adjustedHslColor.toColor();
  }

  static AppColors appInstance() {
    _instance ??= AppColors();
    // primary: 0xff009788, text: 0xff8d8d8d, shade: 0xff8d8d8d
    console(_instance?.primary);
    return _instance!;
  }

  setColors(AppColors appColors) {
    _instance = appColors;
    console(_instance?.primary);
  }

  AppColors get get => AppColors(primary: primary, text: text, shade: shade);
}
