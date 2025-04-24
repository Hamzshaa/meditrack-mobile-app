import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/medication.dart';

class MedicationListItem extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onTap;

  const MedicationListItem({
    super.key,
    required this.medication,
    this.onTap,
  });

  static String formatDistance(double? distanceInMeters) {
    if (distanceInMeters == null) return 'Distance unavailable';

    try {
      if (distanceInMeters < 1000) {
        return '${distanceInMeters.toStringAsFixed(0)} m away';
      } else {
        final distanceInKm = distanceInMeters / 1000.0;

        final format = NumberFormat("##0.0", "en_US");
        return '${format.format(distanceInKm)} km away';
      }
    } catch (e) {
      return 'Distance error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final distanceString =
        MedicationListItem.formatDistance(medication.distance);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.local_pharmacy_outlined,
                color: colorScheme.primary,
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            medication.pharmacyName ?? 'Unknown Pharmacy',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          distanceString,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      medication.medicationBrandName,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (medication.medicationGenericName.isNotEmpty &&
                        medication.medicationGenericName.toLowerCase() !=
                            medication.medicationBrandName.toLowerCase())
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          medication.medicationGenericName,
                          style: textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (medication.strength.isNotEmpty ||
                        medication.dosageForm.isNotEmpty)
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: [
                          if (medication.strength.isNotEmpty)
                            Chip(
                              avatar: Icon(Icons.science_outlined,
                                  size: 16, color: colorScheme.tertiary),
                              label: Text(medication.strength),
                              labelStyle: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onTertiaryContainer),
                              backgroundColor: colorScheme.tertiaryContainer
                                  .withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          if (medication.dosageForm.isNotEmpty)
                            Chip(
                              avatar: Icon(Icons.grain,
                                  size: 16, color: colorScheme.secondary),
                              label: Text(medication.dosageForm),
                              labelStyle: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSecondaryContainer),
                              backgroundColor: colorScheme.secondaryContainer
                                  .withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      )
                  ],
                ),
              ),
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.chevron_right,
                      color: colorScheme.outline.withOpacity(0.7)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
