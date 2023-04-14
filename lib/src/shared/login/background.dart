import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background(
      {super.key, required this.child, required this.backgroudTheme});
  final Widget child;
  final BackgroundTheme backgroudTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BackgroundTheme.defaultTheme == backgroudTheme
            ? Colors.transparent
            : Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            if (backgroudTheme == BackgroundTheme.techTheme)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF113148),
                      Color(0xFF2C5364),
                      Color(0xFF4E6E82),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: CustomPaint(
                        painter: MyPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            if (backgroudTheme == BackgroundTheme.sunSetTheme)
              const SunsetBackground(),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                ],
              ),
            )
          ],
        ));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    var path = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TechBackground extends StatelessWidget {
  const TechBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D2B3E),
                Color(0xFF174758),
                Color(0xFF3E6973),
                Color(0xFF4C7C9B),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: MapPainter(),
          ),
        ),
      ],
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1;

    const distance = 50;
    final xCount = (size.width / distance).ceil();
    final yCount = (size.height / distance).ceil();

    for (int i = 0; i < xCount; i++) {
      for (int j = 0; j < yCount; j++) {
        final startX = i * distance.toDouble();
        final startY = j * distance.toDouble();
        final endX = startX + distance;
        final endY = startY + distance;
        final rect = Rect.fromLTRB(startX, startY, endX, endY);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//SUN SET BACKGROUND

class SunsetBackground extends StatelessWidget {
  const SunsetBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFC371),
            Color(0xFFFFA07A),
            Color(0xFFFF7F50),
            Color(0xFFFF6347),
            Color(0xFF8B0000),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _SunsetPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  'SUNSET',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SunsetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw sun
    paint.shader = LinearGradient(
      colors: [
        const Color(0xFFFFD700).withOpacity(0.5), // Yellow with 50% opacity
        Colors.transparent // Transparent color to create a dissolve effect
      ],
      // stops: [0.7, 1.0], // 70% of the gradient is yellow, 30% is transparent
      // center: Alignment.center,
      // radius: size.width * 0.10,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.7, size.height * 0.45),
        radius: size.width * 0.10,
      ),
    );

// Use BlendMode to make the circle sink and dissolve in the sunset
    // paint.blendMode = BlendMode.darken;

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.45),
      size.width * 0.10,
      paint,
    );

    // Draw clouds
    final cloudGradient = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.8),
        Colors.white.withOpacity(0.4),
        Colors.white.withOpacity(0),
      ],
      stops: const [0, 0.4, 1],
    );

    paint.shader = cloudGradient.createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.2),
        radius: size.width * 0.1,
      ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2),
      size.width * 0.1,
      paint,
    );
    paint.shader = cloudGradient.createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.4, size.height * 0.15),
        radius: size.width * 0.12,
      ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.15),
      size.width * 0.12,
      paint,
    );
    paint.shader = cloudGradient.createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.7, size.height * 0.2),
        radius: size.width * 0.1,
      ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.2),
      size.width * 0.1,
      paint,
    );
    paint.shader = cloudGradient.createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.1),
        radius: size.width * 0.15,
      ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.1),
      size.width * 0.15,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum BackgroundTheme { techTheme, defaultTheme, sunSetTheme }
