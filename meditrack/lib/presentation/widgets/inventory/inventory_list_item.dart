import 'package:flutter/material.dart';
import 'package:meditrack/models/inventory.dart';
import 'package:meditrack/presentation/widgets/inventory/stock_level_indicator.dart';
import 'package:intl/intl.dart';

class InventoryListItem extends StatelessWidget {
  final Inventory inventory;
  final VoidCallback onTap;

  const InventoryListItem({
    super.key,
    required this.inventory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isLowStock = inventory.totalQuantity <= inventory.reorderPoint;

    // Find the earliest expiration date among batches
    DateTime? earliestExpiry;
    if (inventory.inventory.isNotEmpty) {
      inventory.inventory.sort((a, b) {
        if (a.expirationDate == null) return 1;
        if (b.expirationDate == null) return -1;
        return a.expirationDate!.compareTo(b.expirationDate!);
      });
      earliestExpiry = inventory.inventory.first.expirationDate;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: isLowStock
                ? Border.all(
                    color: Colors.red.shade100,
                    width: 2,
                  )
                : null,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inventory.medicationBrandName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          inventory.medicationGenericName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isLowStock
                          ? Colors.red.shade50
                          : colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${inventory.totalQuantity}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isLowStock
                            ? Colors.red.shade700
                            : colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${inventory.strength} ${inventory.dosageForm}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 16,
                        color: isLowStock
                            ? Colors.orange.shade700
                            : colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Reorder at ${inventory.reorderPoint}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isLowStock
                              ? Colors.orange.shade700
                              : colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  if (earliestExpiry != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: earliestExpiry.isBefore(DateTime.now())
                              ? Colors.red.shade700
                              : (earliestExpiry.isBefore(DateTime.now()
                                      .add(const Duration(days: 90))))
                                  ? Colors.orange.shade700
                                  : colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd').format(earliestExpiry),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: earliestExpiry.isBefore(DateTime.now())
                                ? Colors.red.shade700
                                : (earliestExpiry.isBefore(DateTime.now()
                                        .add(const Duration(days: 90))))
                                    ? Colors.orange.shade700
                                    : colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              StockLevelIndicator(
                currentQuantity: inventory.totalQuantity,
                reorderPoint: inventory.reorderPoint,
                maxQuantity: (inventory.reorderPoint * 2)
                    .clamp(inventory.totalQuantity + 10, 10000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
