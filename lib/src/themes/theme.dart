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

  ThemeData customTheme() {
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
      secondary: color.shade50,
      secondaryContainer: color.shade900,
      surface: back.shade600,
      background: back.shade700,
      error: Colors.red,
      onPrimary: text.shade800,
      onSecondary: text.shade800,
      onSurface: text.shade800,
      onBackground: text.shade800,
      onError: text.shade800,
      brightness: isDarkTheme.value ? Brightness.dark : Brightness.light,
    );
    return base.copyWith(
      colorScheme: defaultColorScheme,
      primaryColor: color.shade400,
      scaffoldBackgroundColor:
          isDarkTheme.value ? null : Colors.blueGrey.shade50,
      buttonTheme: ButtonThemeData(buttonColor: color.shade400),
      // appBarTheme: AppBarTheme(backgroundColor: color.shade50),
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
            minimumSize: MaterialStateProperty.all<Size?>(const Size(50, 50)),
            foregroundColor:
                MaterialStateProperty.all<Color?>(const Color(0xfff2f2f2))),
      ),
    );

    // return base;
  }
}
