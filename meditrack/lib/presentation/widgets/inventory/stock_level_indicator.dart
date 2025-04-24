import 'package:flutter/material.dart';
import 'dart:math' as math;

class StockLevelIndicator extends StatelessWidget {
  final int currentQuantity;
  final int reorderPoint;
  final int maxQuantity;

  const StockLevelIndicator({
    super.key,
    required this.currentQuantity,
    required this.reorderPoint,
    required this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double progress =
        math.min(currentQuantity / math.max(maxQuantity, 1), 1.0);
    final double reorderMark =
        math.min(reorderPoint / math.max(maxQuantity, 1), 1.0);

    Color progressColor;
    if (currentQuantity <= 0) {
      progressColor = Colors.grey.shade400;
    } else if (currentQuantity <= reorderPoint) {
      progressColor = Colors.red.shade400;
    } else if (currentQuantity <= reorderPoint * 1.5) {
      progressColor = Colors.orange.shade400;
    } else {
      progressColor = colorScheme.primary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: colorScheme.surfaceVariant.withOpacity(0.4),
          ),
          child: Stack(
            children: [
              // Main progress bar
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      gradient: LinearGradient(
                        colors: [
                          progressColor.withOpacity(0.8),
                          progressColor,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: progressColor.withOpacity(0.2),
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: const Offset(1, 0),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Reorder point marker
              LayoutBuilder(
                builder: (context, constraints) {
                  return Positioned(
                    left: constraints.maxWidth * reorderMark - 1.5,
                    top: -2,
                    bottom: -2,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withOpacity(0.2),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentQuantity in stock',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              'Reorder at $reorderPoint',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
