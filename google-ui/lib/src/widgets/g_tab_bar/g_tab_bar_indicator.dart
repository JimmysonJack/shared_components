import 'package:flutter/material.dart';

class GTabBarIndicator extends Decoration {
  const GTabBarIndicator(this.color);

  final Color color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GTabBarIndicatorPainter(color);
  }
}

class _GTabBarIndicatorPainter extends BoxPainter {
  const _GTabBarIndicatorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    const double height = 3;
    const double borderRadius = 8;

    final rect = Offset(
          offset.dx,
          configuration.size!.height - height,
        ) &
        Size(
          configuration.size!.width,
          height,
        );

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(borderRadius),
        topLeft: const Radius.circular(borderRadius),
      ),
      paint,
    );
  }
}
