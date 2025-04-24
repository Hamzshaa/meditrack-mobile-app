import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/pharmacy_overview_data.dart';

class RecentMedicationsList extends StatelessWidget {
  final List<RecentMedications> medications;
  final DateFormat dateFormat;
  final ThemeData theme;

  const RecentMedicationsList({
    super.key,
    required this.medications,
    required this.dateFormat,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    if (medications.isEmpty) {
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
                Icons.medication_rounded,
                size: 40,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'No recent medications',
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
        children: medications
            .take(5)
            .map((med) => _buildMedicationItem(med, dateFormat, theme))
            .toList(),
      ),
    );
  }
}

Widget _buildMedicationItem(
    RecentMedications med, DateFormat dateFormat, ThemeData theme) {
  final colorScheme = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.medication_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          med.medicationBrandName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${med.strength} • ${med.manufacturer}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: med.createdAt != null
            ? Text(
                dateFormat.format(med.createdAt!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              )
            : null,
      ),
    ),
  );
}
