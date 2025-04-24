import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double minSizeFactor;

  WaveClipper({this.minSizeFactor = 0.75});

  @override
  Path getClip(Size size) {
    var path = Path();
    final minHeight = size.height * minSizeFactor;

    final p1Diff =
        ((minHeight - size.height) * 0.5).clamp(0.0, size.height).toDouble();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 0.4, size.height);
    final endPoint = Offset(size.width, size.height * minSizeFactor);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      oldClipper.minSizeFactor != minSizeFactor;
}
