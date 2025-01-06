import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

class ThemeController extends GetxController {
  static ThemeController? _instance;

  static ThemeController getInstance() {
    _instance ??= ThemeController();
    return _instance!;
  }

  final isDarkTheme = false.obs;
  changeToDarkTheme(bool value) async {
    try {
      var storedStatus = await StorageService.getDarkMode('darkMode');
      if (storedStatus == null) {
        await StorageService.setDarkTheme('darkMode', value);
        isDarkTheme.value = value;
      } else if (storedStatus != value) {
        await StorageService.setDarkTheme('darkMode', value);
        isDarkTheme.value = value;
      } else {
        isDarkTheme.value = storedStatus;
      }
      // onThemeChanged?.call();
    } catch (e) {
      rethrow;
    }
  }

  Color darkMode({required Color darkColor, required Color lightColor}) {
    if (ThemeController.getInstance().isDarkTheme.value) {
      return darkColor;
    }
    return lightColor;
  }

  themInitializer(bool value) async {
    var initData = await StorageService.getDarkMode('darkMode');
    if (initData == null) {
      changeToDarkTheme(value);
    } else {
      changeToDarkTheme(initData);
    }
  }

  ThemeData customThemeChanger(CustomTheme customTheme) {
    if (isDarkTheme.value) {
      return customTheme.dark ?? ThemeData.dark();
    }
    if (!isDarkTheme.value) {
      return customTheme.light ?? ThemeData.light();
    }
    return ThemeData();
  }

  themeChanger(AppColors appColors, CustomTheme? customTheme) {
    AppColors.appInstance().setColors(appColors);
    MaterialColor color =
        isDarkTheme.value ? Palette.defaultDark : Palette.defaultLight;
    MaterialColor text =
        isDarkTheme.value ? Palette.textDark : Palette.textLight;
    MaterialColor back =
        isDarkTheme.value ? Palette.shadeDark : Palette.shadeLight;
    final ThemeData base =
        isDarkTheme.value ? ThemeData.dark() : ThemeData.light();
    if (customTheme != null) {
      return customThemeChanger(customTheme);
    }
    return base.copyWith(
      primaryColor: isDarkTheme.value
          ? Palette.darken(Palette.hexToColor(appColors.primary!), .2)
          : Palette.lighten(Palette.hexToColor(appColors.primary!), .3),
      appBarTheme: AppBarTheme(
        color: isDarkTheme.value
            ? Palette.darken(Palette.hexToColor(appColors.primary!), .2)
            : Palette.lighten(Palette.hexToColor(appColors.primary!)),
      ),
      // colorScheme: isDarkTheme.value
      //     ? const ColorScheme.dark().copyWith(
      //         primary:
      //             Palette.darken(Palette.hexToColor(appColors.primary!), .2),
      //         primaryContainer: color.shade900,
      //         secondary: color.shade200,
      //         secondaryContainer: color.shade900,
      //         surface: back.shade200,
      //         // background: back.shade700,
      //         error: Colors.red,
      //         onPrimary: text.shade800,
      //         onSecondary: text.shade800,
      //         onSurface: text.shade800,
      //         // onBackground: text.shade600,
      //         onError: text.shade800,
      //         brightness:
      //             isDarkTheme.value ? Brightness.dark : Brightness.light,
      //       )
      //     : const ColorScheme.light().copyWith(
      //         primary: Palette.lighten(Palette.hexToColor(appColors.primary!))),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor:
              darkMode(darkColor: Colors.white12, lightColor: Colors.black12),
          labelStyle: TextStyle(
              color: darkMode(
                  darkColor: Colors.white24, lightColor: Colors.black26))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(color.shade50),
            enableFeedback: true,
            minimumSize: WidgetStateProperty.all<Size?>(const Size(50, 50)),
            foregroundColor: isDarkTheme.value
                ? WidgetStateProperty.all<Color?>(const Color(0xfff2f2f2))
                : WidgetStateProperty.all<Color?>(const Color(0xfff2f2f2))),
      ),
    );
  }

  ThemeData customTheme(AppColors appColors) {
    AppColors.appInstance().setColors(appColors);
    final ThemeData base =
        isDarkTheme.value ? ThemeData.dark() : ThemeData.light();
    MaterialColor color =
        isDarkTheme.value ? Palette.defaultDark : Palette.defaultLight;
    MaterialColor text =
        isDarkTheme.value ? Palette.textDark : Palette.textLight;
    MaterialColor back =
        isDarkTheme.value ? Palette.shadeDark : Palette.shadeLight;
    ColorScheme defaultColorScheme = ColorScheme(
      primary: color.shade400,
      primaryContainer: color.shade900,
      secondary: color.shade200,
      secondaryContainer: color.shade900,
      surface: back.shade200,
      // background: back.shade700,
      error: Colors.red,
      onPrimary: text.shade800,
      onSecondary: text.shade800,
      onSurface: text.shade800,
      // onBackground: text.shade600,
      onError: text.shade800,
      brightness: isDarkTheme.value ? Brightness.dark : Brightness.light,
    );
    return base.copyWith(
      // useMaterial3: false,
      colorScheme: defaultColorScheme,
      primaryColor: color.shade400,
      scaffoldBackgroundColor:
          isDarkTheme.value ? null : Colors.blueGrey.shade50,
      buttonTheme: ButtonThemeData(buttonColor: color.shade400),
      inputDecorationTheme:
          InputDecorationTheme(filled: true, fillColor: back.shade300),
      appBarTheme: AppBarTheme(
        backgroundColor: color.shade400.withAlpha(001),
        foregroundColor: color.shade900,
      ),
      // cardTheme: CardTheme(color: color.shade100),
      // scaffoldBackgroundColor: back.shade700,
      // canvasColor: back.shade800,
      // highlightColor: text.shade600,
      // tabBarTheme: TabBarTheme(
      //     indicator: BoxDecoration(color: color.shade100),
      //     unselectedLabelColor: text.shade100),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(color.shade50),
            enableFeedback: true,
            minimumSize: WidgetStateProperty.all<Size?>(const Size(50, 50)),
            foregroundColor:
                WidgetStateProperty.all<Color?>(const Color(0xfff2f2f2))),
      ),
    );

    // return base;
  }
}

class CustomTheme {
  final ThemeData? dark;
  final ThemeData? light;

  CustomTheme({this.dark, this.light});
}
