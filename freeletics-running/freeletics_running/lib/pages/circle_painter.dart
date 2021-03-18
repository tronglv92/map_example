import 'dart:math';

import 'package:flutter/material.dart';



class CirclePainter extends CustomPainter {
  final double currentProgress;
  final Color colorOuter;
  final Color colorComplete;
  final double strokeWidthOuter;
  final double strokeWidthComplete;

  CirclePainter(
      {this.currentProgress,
      this.colorOuter = Colors.white,
      this.colorComplete = Colors.red,
      this.strokeWidthOuter = 10,
      this.strokeWidthComplete = 10});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint outerCircle = Paint()
      ..strokeWidth = strokeWidthOuter
      ..color = colorOuter
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = strokeWidthComplete
      ..color = colorComplete
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    // canvas.drawCircle(center, radius, outerCircle);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        toRadians(135), toRadians(270), false, outerCircle);
    double angle = toRadians(360 - 90) * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        toRadians(135), angle, false, completeArc);
  }

  double toRadians(int degree) {
    return (pi * degree) / 180;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
