import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class XRadialProgress extends StatelessWidget {
  /// A progress value where its range is between (0.0 - 0.1) as [double].
  final double progressValue;

  /// A degrees progress value where its range is between (0 - 360) as [int].
  final int progressValueInDegrees;

  /// The color of the progress circle, [gradient] property must be empty
  /// since only property allowed to use.
  final Color color;

  /// A linear gradient instead of setting only a color, and [color] property
  /// must be empty since only property allowed to use.
  final LinearGradient gradient;

  /// Whether to show the grey circle at the back or not.
  final bool showBackCircle;

  /// Whether to fill the grey circle or not.
  final bool isbackCircleFill;

  /// The [color] of the grey circle at the back.
  final Color backCircleColor;

  /// The [width] of the circle stroke.
  final double width;

  /// A [child] widget where you can set inside the radial progress.
  final Widget child;

  /// [XRadialProgress] simple radial progress to show values in [double, int]
  /// data types, with few interesting properties you can set.
  ///
  /// Written by : AbdulMuaz (Software Developer).
  ///
  /// Github     : https://github.com/abdulmuaz97
  ///
  /// Version    : 0.0.1
  const XRadialProgress({
    Key key,
    this.progressValue,
    this.progressValueInDegrees,
    this.color,
    this.gradient,
    this.showBackCircle = true,
    this.isbackCircleFill = false,
    this.backCircleColor = Colors.black12,
    this.width = 8.0,
    this.child,
  })  : assert(
            (progressValue != null && progressValueInDegrees == null) ||
                (progressValue == null && progressValueInDegrees != null),
            'You can\'t set both of the (progressValue) and (progressValueInDegrees).'),
        assert(color != null || gradient != null, 'Set only one of these properties (color) or (gradient).'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      painter: XRadialProgressPainter(
        progressValue,
        progressValueInDegrees,
        color,
        gradient,
        showBackCircle,
        isbackCircleFill,
        backCircleColor,
        width,
      ),
    );
  }
}

class XRadialProgressPainter extends CustomPainter {
  final double progressValue;
  final int progressValueInDegrees;
  final Color color;
  final LinearGradient gradient;
  final bool showBackCircle;
  final bool isbackCircleFill;
  final Color backCircleColor;
  final double width;

  XRadialProgressPainter(
    this.progressValue,
    this.progressValueInDegrees,
    this.color,
    this.gradient,
    this.showBackCircle,
    this.isbackCircleFill,
    this.backCircleColor,
    this.width,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    // Grey circle
    if (showBackCircle) {
      Paint greyCircle = Paint()
        ..color = backCircleColor
        ..strokeCap = StrokeCap.round
        ..style = isbackCircleFill ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = width;

      canvas.drawCircle(center, size.width / 2, greyCircle);
    }

    // Colored Circle
    if (progressValueInDegrees != null)
      assert(
        progressValueInDegrees >= 0 && progressValueInDegrees <= 360,
        '(progressValueInDegrees) is not with in the range (0 - 360).',
      );
    else
      assert(
        progressValue >= 0.0 && progressValue <= 1.0,
        '(progressValue) is not with in the range (0.0 - 1.0).',
      );
    Paint coloredCircle = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    if (gradient != null)
      coloredCircle.shader = gradient.createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    else
      coloredCircle.color = color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(
        -(progressValue != null ? progressValue * 360 : progressValueInDegrees.toDouble()),
      ),
      false,
      coloredCircle,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
