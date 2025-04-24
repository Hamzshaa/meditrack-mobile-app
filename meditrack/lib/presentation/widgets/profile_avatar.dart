import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.radius = 40,
    this.fontSize = 20,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((part) => part.isNotEmpty);
    if (parts.isEmpty) return '?';
    String initials = parts.first[0];
    if (parts.length > 1) {
      initials += parts.last[0];
    }
    return initials.toUpperCase();
  }

  Color _getColorFromName(String name) {
    // Simple hash-based color generation for consistent avatar colors per name
    final int hash = name.hashCode;
    final double hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.4, 0.6)
        .toColor(); // Adjust saturation/lightness
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final color = _getColorFromName(name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
