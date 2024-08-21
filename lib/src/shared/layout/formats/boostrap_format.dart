// ignore_for_file: overridden_fields

import '../breakpoint.dart';
import '../format.dart';
import '../value.dart';

class BoostrapLayoutFormat extends LayoutFormat {
  BoostrapLayoutFormat({
    LayoutValue<double>? margin,
  }) : margin = margin ?? const ConstantLayoutValue(0);

  @override
  final LayoutValue<double> gutter = const ConstantLayoutValue(30.0);

  @override
  final LayoutValue<double> margin;

  @override
  Map<LayoutBreakpoint, double> get breakpoints => {
        LayoutBreakpoint.xs: 0,
        LayoutBreakpoint.sm: 576,
        LayoutBreakpoint.md: 768,
        LayoutBreakpoint.lg: 992,
        LayoutBreakpoint.xl: 1200,
      };

  @override
  final LayoutValue<double> maxWidth = const BreakpointValue.all(
    xs: 576, // Always maxWitdh == width
    sm: 540,
    md: 720,
    lg: 960,
    xl: 1140,
  );
}
