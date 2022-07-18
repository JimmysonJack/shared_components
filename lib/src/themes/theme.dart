import 'package:flutter/material.dart';

import 'default.dart';

ThemeData customTheme(bool isDarkTheme) {
  final ThemeData base = isDarkTheme ? ThemeData.dark() : ThemeData.light();
  MaterialColor color =
      isDarkTheme ? Palette.defaultDark : Palette.defaultLight;
  MaterialColor text = isDarkTheme ? Palette.textDark : Palette.textLight;
  MaterialColor back = isDarkTheme ? Palette.shadeDark : Palette.shadeLight;
  ColorScheme defaultColorScheme = ColorScheme(
    primary: color.shade400,
    primaryContainer: color.shade900,
    secondary: color.shade50,
    secondaryContainer: color.shade900,
    surface: back.shade800,
    background: back.shade900,
    error: Colors.red,
    onPrimary: text.shade800,
    onSecondary: text.shade800,
    onSurface: text.shade800,
    onBackground: text.shade800,
    onError: text.shade800,
    brightness: isDarkTheme ? Brightness.dark : Brightness.light,
  );
  return base.copyWith(
    colorScheme: defaultColorScheme,
    primaryColor: color.shade100,
    // buttonTheme: const ButtonThemeData(
    //   buttonColor: Colors.blue
    // ),
    // accentColor: color.shade600,
    appBarTheme: AppBarTheme(backgroundColor: color.shade50),
    // buttonColor: color.shade100,
    errorColor: Colors.red,
    cardTheme: CardTheme(color: color.shade100),
    textTheme: TextTheme(
        bodyText2: TextStyle(color: text.shade700),
        headline6: TextStyle(color: text.shade700, fontSize: 18),
        button: const TextStyle(color: Color(0xfff2f2f2), fontSize: 16)),
    backgroundColor: back.shade600,
    scaffoldBackgroundColor: back.shade700,
    canvasColor: back.shade800,
    highlightColor: text.shade600,
    tabBarTheme: TabBarTheme(
        indicator: BoxDecoration(color: color.shade100),
        unselectedLabelColor: text.shade100),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(color.shade50),
          enableFeedback: true,
            fixedSize: MaterialStateProperty.all<Size?>(const Size(1000,40)),
          foregroundColor: MaterialStateProperty.all<Color?>(const Color(0xfff2f2f2))
        ),
    ),
    toggleableActiveColor: color.shade200,

    // //  primaryColor: isDarkTheme ? Color(0xFF0054BB) : Color(0xFF4285F4),
    //   accentColor: Color(0xFF659fff),
    //   scaffoldBackgroundColor:
    //       isDarkTheme ? Color(0xFF1E1E1E) : Color(0xFFE8E9Ea),
    //   dividerColor: isDarkTheme ? Color(0xFF787f7f) : Color(0xFFB8BfBf),
    //   hoverColor: isDarkTheme ? Color(0x0FFFFFFF) : Color(0x0F000000),
    //   brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    //   appBarTheme: AppBarTheme(
    //       backgroundColor: isDarkTheme ? Color(0xFF009788) : Color(0xFF009788)),
  );

  // return base;
}
