// ignore_for_file: overridden_fields

import 'dart:math';

import '../breakpoint.dart';
import '../format.dart';
import '../value.dart';

class FluidLayoutFormat extends LayoutFormat {
  FluidLayoutFormat({
    LayoutValue<double>? margin,
  }) : this.margin = margin ?? _defaultMargin;

  @override
  LayoutValue<double> get maxWidth {
    return LayoutValue.builder(
      (layout) {
        final width = layout.width;
        final breakpoint = breakpointForWidth(width);
        switch (breakpoint) {
          case LayoutBreakpoint.xs:
            return min(width, maxFluidWidth[breakpoint]!);
          case LayoutBreakpoint.sm:
          case LayoutBreakpoint.md:
          case LayoutBreakpoint.lg:
            return calculateFluidWidth(breakpoint, width);
          case LayoutBreakpoint.xl:
            return maxFluidWidth[breakpoint]!;
        }
      },
    );
  }

  double calculateFluidWidth(LayoutBreakpoint breakpoint, double layoutWidth) {
    //Distance to next width breakpoint
    final width = breakpoints[breakpoint] ?? layoutWidth;

    final currentDistance = width - layoutWidth;

    final totalDistance = width - breakpoints[breakpoint.smaller]!;

    final totalFluidDistance =
        maxFluidWidth[breakpoint]! - maxFluidWidth[breakpoint.smaller]!;
    final progress = currentDistance / totalDistance;
    final maxFluid =
        maxFluidWidth[breakpoint.bigger]! - totalFluidDistance * progress;
    return maxFluid;
  }

  @override
  LayoutValue<double> get gutter {
    const double spacer = 16;
    return const BreakpointValue<double>.all(
      xs: spacer * 1,
      sm: spacer * 1.25,
      md: spacer * 1.5,
      lg: spacer * 2,
      xl: spacer * 3,
    );
  }

  @override
  LayoutValue<int> get columns => const ConstantLayoutValue(12);

  @override
  final LayoutValue<double> margin;

  static final LayoutValue<double> _defaultMargin = LayoutValue.builder(
    (layout) {
      return layout.width <= 719 ? 16 : 24;
    },
  );

  @override
  Map<LayoutBreakpoint, double> get breakpoints => {
        LayoutBreakpoint.xs: 0,
        LayoutBreakpoint.sm: 576,
        LayoutBreakpoint.md: 768,
        LayoutBreakpoint.lg: 992,
        LayoutBreakpoint.xl: 1200,
      };

  Map<LayoutBreakpoint, double> get maxFluidWidth => {
        LayoutBreakpoint.xs: 540,
        LayoutBreakpoint.sm: 540,
        LayoutBreakpoint.md: 720,
        LayoutBreakpoint.lg: 960,
        LayoutBreakpoint.xl: 1140,
      };
}
