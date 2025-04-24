import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class CurvedSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeaderHeight;
  final double minHeaderHeight;
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? foregroundColor;

  CurvedSliverAppBarDelegate({
    required this.maxHeaderHeight,
    required this.minHeaderHeight,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.gradient,
    this.foregroundColor,
  })  : assert(title != null || titleText != null,
            'Must provide either title Widget or titleText String.'),
        assert(backgroundColor != null || gradient != null,
            'Must provide either backgroundColor or gradient.');

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final appBarTheme = AppBarTheme.of(context);
    final currentHeight =
        math.max(minHeaderHeight, maxHeaderHeight - shrinkOffset);

    final shrinkRatio = maxHeaderHeight == minHeaderHeight
        ? 0.0
        : (shrinkOffset / (maxHeaderHeight - minHeaderHeight)).clamp(0.0, 1.0);

    final effectiveForegroundColor = foregroundColor ??
        appBarTheme.foregroundColor ??
        theme.colorScheme.onPrimary;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;

    final effectiveIconTheme = appBarTheme.iconTheme ??
        theme.iconTheme.copyWith(color: effectiveForegroundColor);
    final effectiveActionsIconTheme =
        appBarTheme.actionsIconTheme ?? effectiveIconTheme;

    final contentOffset = Tween<double>(begin: 30.0, end: 0.0)
        .transform(Curves.easeOutQuad.transform(1 - shrinkRatio));
    final contentOpacity = Curves.easeInOutQuad.transform(shrinkRatio);
    final expandedTitleOpacity =
        Curves.easeOutQuad.transform(1.0 - shrinkRatio);

    final collapsedTextStyle = GoogleFonts.merienda(
      textStyle: appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge,
      color: effectiveForegroundColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.1 * shrinkRatio),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );

    final expandedTextStyle = GoogleFonts.merienda(
      textStyle: theme.textTheme.headlineSmall,
      color: effectiveForegroundColor,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.1 * (1 - shrinkRatio)),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final Widget finalTitleWidget =
        title ?? Text(titleText ?? '', style: collapsedTextStyle);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _WaveClipper(currentHeight, shrinkRatio),
            child: Container(
              height: currentHeight,
              decoration: BoxDecoration(
                gradient: gradient ??
                    LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        effectiveBackgroundColor,
                        effectiveBackgroundColor.withOpacity(0.9),
                      ],
                    ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: minHeaderHeight - MediaQuery.of(context).padding.top,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Opacity(
                opacity: contentOpacity,
                child: Row(
                  children: [
                    if (leading != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Theme(
                          data: theme.copyWith(iconTheme: effectiveIconTheme),
                          child: leading!,
                        ),
                      ),
                    Expanded(
                      child: DefaultTextStyle(
                        style: collapsedTextStyle,
                        textAlign: leading == null
                            ? TextAlign.center
                            : TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: finalTitleWidget,
                      ),
                    ),
                    if (actions != null)
                      Theme(
                        data: theme.copyWith(
                            iconTheme: effectiveActionsIconTheme),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: actions!
                              .map((action) => Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: action,
                                  ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top +
              kToolbarHeight / 2 +
              contentOffset * 1.5,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: expandedTitleOpacity,
            child: DefaultTextStyle(
              style: expandedTextStyle,
              textAlign: TextAlign.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: finalTitleWidget,
              ),
            ),
          ),
        ),
        // Optional: You can replace this with a white gradient if needed, or remove it completely
        // In this version, we completely remove the grayish gradient fade
      ],
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant CurvedSliverAppBarDelegate oldDelegate) {
    return oldDelegate.maxHeaderHeight != maxHeaderHeight ||
        oldDelegate.minHeaderHeight != minHeaderHeight ||
        oldDelegate.title != title ||
        oldDelegate.titleText != titleText ||
        oldDelegate.actions != actions ||
        oldDelegate.leading != leading ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gradient != gradient ||
        oldDelegate.foregroundColor != foregroundColor;
  }

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
}

class _WaveClipper extends CustomClipper<Path> {
  final double height;
  final double shrinkRatio;

  _WaveClipper(this.height, this.shrinkRatio);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, height - 40 * (1 - shrinkRatio));

    final waveHeight = 40 * (1 - shrinkRatio);

    path.cubicTo(
      size.width / 4,
      height - waveHeight,
      size.width * 3 / 4,
      height - waveHeight * 1.5,
      size.width,
      height - waveHeight,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) =>
      oldClipper.height != height || oldClipper.shrinkRatio != shrinkRatio;
}
