// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MediTrackLogo extends StatelessWidget {
  final LogoSize size;
  final bool showUnderline;
  final Color? color;
  final Color? underlineColor;

  const MediTrackLogo({
    super.key,
    this.size = LogoSize.medium,
    this.showUnderline = true,
    this.color,
    this.underlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double fontSize;
    final double underlineWidth;

    switch (size) {
      case LogoSize.small:
        fontSize = 24;
        underlineWidth = 40;
        break;
      case LogoSize.medium:
        fontSize = 36;
        underlineWidth = 60;
        break;
      case LogoSize.large:
        fontSize = 48;
        underlineWidth = 80;
        break;
      case LogoSize.xlarge:
        fontSize = 64;
        underlineWidth = 100;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'MediTrack',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color ?? theme.colorScheme.primary,
            letterSpacing: 1.5,
          ),
        ),
        if (showUnderline)
          Container(
            height: 4,
            width: underlineWidth,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: underlineColor ?? theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

enum LogoSize {
  small,
  medium,
  large,
  xlarge,
}
