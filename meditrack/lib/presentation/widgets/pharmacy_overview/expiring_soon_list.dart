import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/pharmacy_overview_data.dart';

class ExpiringSoonList extends StatelessWidget {
  final List<ExpiringSoon> expiring;
  final DateFormat dateFormat;
  final ThemeData theme;

  const ExpiringSoonList({
    super.key,
    required this.expiring,
    required this.dateFormat,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final warningColor = Colors.orange.shade700;

    if (expiring.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.hourglass_bottom_rounded,
                size: 40,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'No items expiring soon',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: expiring
            .take(5)
            .map((item) =>
                _buildExpiringItem(item, dateFormat, theme, warningColor))
            .toList(),
      ),
    );
  }
}

Widget _buildExpiringItem(
  ExpiringSoon item,
  DateFormat dateFormat,
  ThemeData theme,
  Color warningColor,
) {
  final colorScheme = theme.colorScheme;
  final dateText = item.expirationDate != null
      ? dateFormat.format(item.expirationDate!)
      : 'N/A';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        color: warningColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: warningColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.hourglass_bottom_rounded,
            color: warningColor,
            size: 20,
          ),
        ),
        title: Text(
          item.medicationBrandName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batch: ${item.batchNumber} • ${item.strength}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Qty: ${item.quantity} • Expires: $dateText',
              style: theme.textTheme.bodySmall?.copyWith(
                color: warningColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
