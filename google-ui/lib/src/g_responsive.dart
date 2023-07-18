import 'package:flutter/cupertino.dart';

/// An utility that responsible for responsive view
class GResponsive {
  /// Set breakpoint value for small screen
  static double smallBreakpoint = 640;

  /// Set breakpoint value for medium screen
  static double mediumBreakpoint = 1008;

  /// Return T value based on screen width
  static T on<T>(
    BuildContext context, {
    required T initial,
    T? small,
    T? medium,
    T? large,
  }) {
    final screenSize = MediaQuery.of(context).size.width;

    if (screenSize <= smallBreakpoint) return small ?? initial;
    if (screenSize <= mediumBreakpoint) return medium ?? initial;
    return large ?? initial;
  }

  /// Return true if screen width lower than or equals to [smallBreakpoint]
  static bool isSmall(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    return screenSize <= smallBreakpoint;
  }

  /// Return true if screen width bigger than [smallBreakpoint] and
  /// lower than or equals to [mediumBreakpoint]
  static bool isMedium(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    return screenSize > smallBreakpoint && screenSize <= mediumBreakpoint;
  }

  /// Return true if screen width bigger than [mediumBreakpoint]
  static bool isLarge(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    return screenSize > mediumBreakpoint;
  }
}
