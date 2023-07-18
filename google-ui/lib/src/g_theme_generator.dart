import 'package:flutter/material.dart';

import 'widgets/g_tab_bar/g_tab_bar_indicator.dart';

/// Generate a theme.
class GThemeGenerator {
  static const ColorScheme _colorScheme = ColorScheme(
    primary: Color(0xFF1A73E9),
    secondary: Color(0xFF1A73E9),
    surface: Colors.white,
    background: Colors.white,
    error: Color(0xFFC6074A),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF3C4043),
    onBackground: Color(0xFF3C4043),
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Color(0xFF89B4F8),
    secondary: Color(0xFF89B4F8),
    surface: Color(0xFF303135),
    background: Color(0xFF202125),
    error: Color(0xFFC6074A),
    onPrimary: Color(0xFF202125),
    onSecondary: Color(0xFF202125),
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 93,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontSize: 58,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontSize: 46,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontSize: 33,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headlineSmall: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    labelLarge: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );

  /// Generate a theme, if [colorScheme] is null, default light [colorScheme] used.
  static ThemeData generate({ColorScheme? colorScheme}) {
    return _generateThemeData(colorScheme ?? _colorScheme);
  }

  /// Generate a dark theme using default dark [colorScheme].
  static ThemeData generateDark() {
    return _generateThemeData(_darkColorScheme);
  }

  static ThemeData _generateThemeData(ColorScheme colorScheme) {
    return ThemeData(
      visualDensity: VisualDensity.standard,
      fontFamily: "Poppins",
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      indicatorColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      popupMenuTheme: PopupMenuThemeData(color: colorScheme.surface),
      dialogBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.onBackground),
      textTheme: _textTheme.apply(
        displayColor: colorScheme.onBackground,
        bodyColor: colorScheme.onBackground,
        decorationColor: colorScheme.onBackground,
      ),
      dividerColor: colorScheme.onBackground.withOpacity(.25),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.onBackground.withOpacity(.75),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        shadowColor: colorScheme.brightness == Brightness.light
            ? Colors.white70
            : Colors.black45,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.75),
        selectedLabelStyle: _textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: _textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(.75),
        indicator: GTabBarIndicator(colorScheme.primary),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => colorScheme.primary,
          ),
          overlayColor: MaterialStateColor.resolveWith(
            (states) => Colors.black.withOpacity(.25),
          ),
          elevation: MaterialStateProperty.resolveWith(
            (states) {
              const pressedState = MaterialState.pressed;
              const hoveredState = MaterialState.hovered;
              final isHoveredOrPressed = states
                  .where((e) => e == pressedState || e == hoveredState)
                  .isNotEmpty;

              if (isHoveredOrPressed) return 3;
              return 0;
            },
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
      ), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return colorScheme.primary; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return colorScheme.primary; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return colorScheme.primary; }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return colorScheme.primary; }
 return null;
 }),
 ),
    );
  }
}
