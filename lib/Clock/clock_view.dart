import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  const ClockView({super.key, required this.size});
  final double size;
  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var fillBrush = Paint()..color = const Color.fromARGB(110, 255, 255, 255);

    var outlineBrush = Paint()
      ..color = const Color.fromARGB(80, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 10;

    var outlineBrushMax = Paint()
      ..color = const Color.fromARGB(50, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 10;

    var secHandBrush = Paint()
      ..color = const Color.fromARGB(90, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 60;

    var minHandBrush = Paint()
      ..color = const Color.fromARGB(70, 255, 255, 255)
      /*..shader =
      const RadialGradient(colors: [Color.fromARGB(90, 255, 255, 255), Color(0x00000000)])
          .createShader(Rect.fromCircle(center: center, radius: radius))*/
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 30;

    var hourHandBrush = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 24;

    canvas.drawCircle(center, radius * 0.70, fillBrush);
    canvas.drawCircle(center, radius * 0.80, outlineBrush);
    canvas.drawCircle(center, radius * 1.0, outlineBrushMax);

    var hourHandX = centerX +
        radius *
            0.35 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        radius *
            0.35 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + radius * 0.5 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + radius * 0.5 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.6 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
