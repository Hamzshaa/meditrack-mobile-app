// lib/presentation/widgets/settings/theme_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/providers/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  final Color? iconColor;

  const ThemeToggleButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Brightness currentBrightness = Theme.of(context).brightness;
    final Color effectiveIconColor =
        iconColor ?? IconTheme.of(context).color ?? Colors.grey;

    return GestureDetector(
      onTap: () {
        if (currentBrightness == Brightness.dark) {
          ref
              .read(themeNotifierProvider.notifier)
              .setThemeMode(ThemeMode.light);
        } else {
          ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.dark);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeInBack,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          currentBrightness == Brightness.dark
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          key: ValueKey(currentBrightness),
          color: effectiveIconColor,
          size: 26,
        ),
      ),
    );
  }
}
