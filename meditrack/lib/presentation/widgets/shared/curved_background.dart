import 'package:flutter/material.dart';
import 'wave_clipper.dart';

class CurvedBackground extends StatelessWidget {
  final double height;
  final Color? color;
  final Gradient? gradient;

  const CurvedBackground({
    super.key,
    required this.height,
    this.color,
    this.gradient,
  }) : assert(color != null || gradient != null,
            'Must provide either a color or a gradient.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
          ),
        ),
      ),
    );
  }
}
